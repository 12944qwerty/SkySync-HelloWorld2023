import Foundation
import CoreBluetooth

class BluetoothManager: NSObject, CBCentralManagerDelegate, CBPeripheralManagerDelegate, CBPeripheralDelegate, ObservableObject {
    var userName: String
    
    private let serviceUUID = CBUUID(string: "F54BDA68-017A-4A83-A23D-76E2F1C20E1E")
    private let characteristicUUID = CBUUID(string: "E4870E58-A740-489F-8AC8-41A6A6D3DBE8")

    private var centralManager: CBCentralManager!
    private var peripheralManager: CBPeripheralManager!
    private var readCallbacks: [String: (Data) -> Void] = [:]
    
    private var queue: [String] = []
    
    var timer: Timer!
    
    @Published var connectedPeripheral: CBPeripheral?
    @Published var isConnected: Bool = false
    
    @Published var discoveredPeripherals: [CBPeripheral] = []
    @Published var discoveredNames: [UUID:String] = [:]

    init(_ userName: String) {
        self.userName = userName
        
        super.init()
        
        centralManager = CBCentralManager(delegate: self, queue: nil)
        peripheralManager = CBPeripheralManager(delegate: self, queue: nil)
    }

    // MARK: Central

    func startScanning() {
        centralManager.scanForPeripherals(withServices: [serviceUUID], options: nil)
    }

    func stopScanning() {
        centralManager.stopScan()
    }

    func connect(to peripheral: CBPeripheral) {
        centralManager.connect(peripheral, options: nil)
    }

    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if central.state == .poweredOn {
            startScanning()
        }
    }

    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        if !discoveredPeripherals.contains(where: { $0.identifier == peripheral.identifier }) {
            print("DEBUG: Device found - \(peripheral.name ?? "")")
            
            discoveredPeripherals.append(peripheral)
            discoveredNames[peripheral.identifier] = advertisementData[CBAdvertisementDataLocalNameKey] as? String
        }
    }

    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        peripheral.delegate = self
        peripheral.discoverServices(nil)
    }
    
    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        print(error as Any)
    }

    // MARK: Peripheral

    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        guard let services = peripheral.services else { return }
        for service in services {
            if service.uuid == serviceUUID {
                peripheral.discoverCharacteristics([characteristicUUID], for: service)
            }
        }
    }

    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        guard let characteristics = service.characteristics else { return }
        for characteristic in characteristics {
            if characteristic.uuid == characteristicUUID {
                print("DEBUG: Sending a message")
                let data = queue.popLast()?.data(using: .utf8)
                peripheral.writeValue(data!, for: characteristic, type: CBCharacteristicWriteType.withResponse)
            }
        }
    }

    // MARK: - Server Side (Peripheral Role)

    func startAdvertising() {
        let service = CBMutableService(type: serviceUUID, primary: true)
        
        // Allow the characteristic to be written to by a Central
        let characteristic = CBMutableCharacteristic(type: characteristicUUID,
                                                     properties: [.read, .write, .notify],
                                                     value: nil,
                                                     permissions: [.readable, .writeable])
        
        service.characteristics = [characteristic]
        peripheralManager.add(service)

        peripheralManager.startAdvertising([
            CBAdvertisementDataServiceUUIDsKey: [serviceUUID],
            CBAdvertisementDataLocalNameKey: userName
        ])
    }

        // ... (Keep the CBPeripheralManagerDelegate unchanged)


    func stopAdvertising() {
        peripheralManager.stopAdvertising()
    }

    // MARK: - CBPeripheralManagerDelegate

    func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
        switch peripheral.state {
        case .poweredOn:
            startAdvertising()
        default:
            stopAdvertising()
        }
    }

    func peripheralManager(_ peripheral: CBPeripheralManager, didReceiveWrite requests: [CBATTRequest]) {
        print("DEBUG: Received message. \(Int.random(in: 1...1000))")
        for request in requests {
            if let value = request.value {
                for (_, callback) in readCallbacks {
                    callback(value)
                }
            }
            peripheralManager.respond(to: request, withResult: .success)
        }
    }

    // MARK: - General Utility Functions

    func addReadCallback(id: String, callback: @escaping (Data) -> Void) {
        readCallbacks[id] = callback
    }
    
    func removeReadCallback(id: String) {
        readCallbacks.removeValue(forKey: id)
    }

    func sendMessage(_ message: String, to peripheral: CBPeripheral) {
        queue.insert(message, at: 0)
        centralManager.connect(peripheral, options: nil)
    }
}
