//import Foundation
//import CoreBluetooth
//
//class BluetoothManager: NSObject, CBCentralManagerDelegate, CBPeripheralManagerDelegate, CBPeripheralDelegate, ObservableObject {
//
//    private let serviceUUID = CBUUID(string: "F54BDA68-017A-4A83-A23D-76E2F1C20E1E")
//    private let characteristicUUID = CBUUID(string: "E4870E58-A740-489F-8AC8-41A6A6D3DBE8")
//
//    private var centralManager: CBCentralManager!
//    private var peripheralManager: CBPeripheralManager!
//    var discoveredPeripherals: [CBPeripheral] = []
//    private var readCallbacks: [(Data) -> Void] = []
//    
//    @Published var connectedPeripheral: CBPeripheral?
//    @Published var isConnected: Bool = false
//
//    @Published var discoveredNames: [String] = []
//
//    override init() {
//        super.init()
//        centralManager = CBCentralManager(delegate: self, queue: nil)
//        peripheralManager = CBPeripheralManager(delegate: self, queue: nil)
//    }
//
//    // MARK: Central
//
//    func startScanning() {
//        centralManager.scanForPeripherals(withServices: [serviceUUID], options: nil)
//    }
//
//    func stopScanning() {
//        centralManager.stopScan()
//    }
//
//    func connect(to peripheral: CBPeripheral) {
//        centralManager.connect(peripheral, options: nil)
//    }
//
//    func centralManagerDidUpdateState(_ central: CBCentralManager) {
//        if central.state == .poweredOn {
//            startScanning()
//        }
//    }
//
//    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
//        if !discoveredPeripherals.contains(where: { $0.identifier == peripheral.identifier }) {
//            discoveredPeripherals.append(peripheral)
//            if let name = peripheral.name {
//                discoveredNames.append(name)
//                print("DEBUG: Device found - \(name)")
//            }
//        }
//    }
//
//    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
//        print("Connected")
//        connectedPeripheral = peripheral
//        isConnected = true
//        
//        peripheral.delegate = self
//        peripheral.discoverServices([serviceUUID])
//    }
//    
//    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
//        print(error)
//    }
//
//    // MARK: Peripheral
//
//    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
//        guard let services = peripheral.services else { return }
//        for service in services {
//            if service.uuid == serviceUUID {
//                peripheral.discoverCharacteristics([characteristicUUID], for: service)
//            }
//        }
//    }
//
//    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
//        guard let characteristics = service.characteristics else { return }
//        for characteristic in characteristics {
//            if characteristic.uuid == characteristicUUID {
//                // Read value if needed
//                 peripheral.readValue(for: characteristic)
//            }
//        }
//    }
//
//    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
//        if let data = characteristic.value {
//            print(String(data: data, encoding: .utf8))
//            for callback in readCallbacks {
//                callback(data)
//            }
//        }
//    }
//
//    // MARK: - Server Side (Peripheral Role)
//
//    func startAdvertising() {
//        let service = CBMutableService(type: serviceUUID, primary: true)
//        
//        // Allow the characteristic to be written to by a Central
//        let characteristic = CBMutableCharacteristic(type: characteristicUUID,
//                                                     properties: [.read, .write, .notify],
//                                                     value: nil,
//                                                     permissions: [.readable, .writeable])
//        
//        service.characteristics = [characteristic]
//        peripheralManager.add(service)
//
//        peripheralManager.startAdvertising([CBAdvertisementDataLocalNameKey: "Your Device Name",
//                                            CBAdvertisementDataServiceUUIDsKey: [serviceUUID]])
//    }
//
//        // ... (Keep the CBPeripheralManagerDelegate unchanged)
//
//
//    func stopAdvertising() {
//        peripheralManager.stopAdvertising()
//    }
//
//    // MARK: - CBPeripheralManagerDelegate
//
//    func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
//        switch peripheral.state {
//        case .poweredOn:
//            startAdvertising()
//        default:
//            stopAdvertising()
//        }
//    }
//
//    func peripheralManager(_ peripheral: CBPeripheralManager, central: CBCentral, didSubscribeTo characteristic: CBCharacteristic) {
//        print("Central \(central.identifier) has subscribed to \(characteristic.uuid)")
//    }
//
//    func peripheralManager(_ peripheral: CBPeripheralManager, central: CBCentral, didUnsubscribeFrom characteristic: CBCharacteristic) {
//        print("Central \(central.identifier) has unsubscribed from \(characteristic.uuid)")
//    }
//
//    func peripheralManager(_ peripheral: CBPeripheralManager, didReceiveRead request: CBATTRequest) {
//        if request.characteristic.uuid == characteristicUUID {
//            // When you click on another phone, this is called. This sends to them right after that.
//            request.value = "Hello there ".data(using: .utf8)
//                      
//            peripheralManager.respond(to: request, withResult: .success)
//        }
//    }
//    func peripheralManager(_ peripheral: CBPeripheralManager, didReceiveWrite request: CBATTRequest) {
//        print(request)
//        if request.characteristic.uuid == characteristicUUID {
//            print("didwrite")
//            request.value = "didReceiveWrite".data(using: .utf8)
//            print(request.value)
//            print(request.characteristic.value)
//            peripheralManager.respond(to: request, withResult: .success)
//        }
//    }
//
//    // MARK: - General Utility Functions
//
//    func addReadCallback(callback: @escaping (Data) -> Void) {
//        readCallbacks.append(callback)
//    }
//
//    func sendData(data: Data, to peripheral: CBPeripheral) {
//        guard let characteristic = peripheral.services?.first(where: { $0.uuid == serviceUUID })?.characteristics?.first(where: { $0.uuid == characteristicUUID }) else {
//            return
//        }
//        peripheral.writeValue(data, for: characteristic, type: .withResponse)
//    }
//}
