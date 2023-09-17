import Foundation
import CoreBluetooth

class BluetoothManager: NSObject, CBCentralManagerDelegate, CBPeripheralManagerDelegate, CBPeripheralDelegate, ObservableObject {
    
    // MARK: Properties
    var centralManager: CBCentralManager!
    @Published var discoveredPeripherals: [CBPeripheral] = []
    var connectedPeripheral: CBPeripheral?
    

    private var peripheralManager: CBPeripheralManager!
    private var characteristic: CBMutableCharacteristic!
    var targetCharacteristic: CBCharacteristic?
    
    // UUIDs
    let serviceUUID = CBUUID(string: "F54BDA68-017A-4A83-A23D-76E2F1C20E1E")
    let characteristicUUID = CBUUID(string: "E4870E58-A740-489F-8AC8-41A6A6D3DBE8")
    
    // Observable properties
    @Published var isConnected: Bool = false
    @Published var receivedMessage: String?
    
    override init() {
        super.init()
        centralManager = CBCentralManager(delegate: self, queue: nil)
        peripheralManager = CBPeripheralManager(delegate: self, queue: nil)
    }

    // MARK: Central Methods

    func startScanning() {
        discoveredPeripherals.removeAll()
        centralManager.scanForPeripherals(withServices: [serviceUUID], options: nil)
    }

    func connect(to peripheral: CBPeripheral) {
        centralManager.connect(peripheral, options: nil)
        connectedPeripheral = peripheral
        print("Central connecting to peripheral")
    }
    
    func sendMessage(_ message: String) {
        print("Attempting to send message")
        guard let data = message.data(using: .utf8) else {return}
        guard let characteristic = targetCharacteristic else {return}
        guard let peripheral = connectedPeripheral else {return}
        
        peripheral.writeValue(data, for: characteristic, type: .withResponse)
        print("Message Sent")
    }
    
    // MARK: Peripheral Methods
    
    func startAdvertising() {
        let service = CBMutableService(type: serviceUUID, primary: true)
        
        // Set all relevant properties
        let properties: CBCharacteristicProperties = [.read, .write, .notify, .writeWithoutResponse, .indicate, .authenticatedSignedWrites, .extendedProperties]
        
        // Set permissions based on the properties
        var permissions: CBAttributePermissions = []
        if properties.contains(.read) {
            permissions.insert(.readable)
        }
        if properties.contains(.write) || properties.contains(.writeWithoutResponse) {
            permissions.insert(.writeable)
        }
        if properties.contains(.notify) || properties.contains(.indicate) {
            permissions.insert(.readEncryptionRequired) // often required for notifications
        }
        
        characteristic = CBMutableCharacteristic(type: characteristicUUID, properties: properties, value: nil, permissions: permissions)
        service.characteristics = [characteristic]
        peripheralManager.add(service)
        let advertisementData = [CBAdvertisementDataServiceUUIDsKey: [serviceUUID]]
        peripheralManager.startAdvertising(advertisementData)
    }

    // MARK: CBCentralManagerDelegate Methods
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        if !discoveredPeripherals.contains(where: { $0.identifier == peripheral.identifier }) {
            discoveredPeripherals.append(peripheral)
        }
    }
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state {
        case .poweredOn:
            print("Central is powered on.")
            startScanning()
        case .poweredOff:
            print("Central is powered off.")
        default:
            break
        }
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("Connected to \(peripheral.name ?? "a peripheral").")
        peripheral.delegate = self
        peripheral.discoverServices([serviceUUID])
    }

    // MARK: CBPeripheralDelegate Methods

    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        if let error = error {
            print("Error discovering services: \(error.localizedDescription)")
            return
        }

        if let service = peripheral.services?.first(where: { $0.uuid == serviceUUID }) {
            peripheral.discoverCharacteristics([characteristicUUID], for: service)
        }
    }

    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        if let error = error {
            print("Error discovering characteristics: \(error.localizedDescription)")
            return
        }
        
        if let discoveredCharacteristic = service.characteristics?.first(where: { $0.uuid == characteristicUUID }) {
            targetCharacteristic = discoveredCharacteristic
        }
        // Here you can perform actions like reading, writing or subscribing to changes
    }

    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        if let error = error {
            print("Error writing value: \(error.localizedDescription)")
            return
        }
        print("Value change received")
        if let data = characteristic.value, let message = String(data: data, encoding: .utf8) {
            self.receivedMessage = message
            print("Message Received")
        }
    }
    func peripheral(_ peripheral: CBPeripheral, didWriteValueFor characteristic: CBCharacteristic, error: Error?) {
        if let error = error {
            print("Error writing value: \(error.localizedDescription)")
            return
        }
        print("Value written successfully")
    }

    // MARK: CBPeripheralManagerDelegate Methods
    
    func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
        switch peripheral.state {
        case .poweredOn:
            print("Peripheral is powered on.")
            startAdvertising()
        case .poweredOff:
            print("Peripheral is powered off.")
        default:
            break
        }
    }

    // Add other peripheral delegate methods like didReceiveRead, didReceiveWrite, etc. if needed
    
}
