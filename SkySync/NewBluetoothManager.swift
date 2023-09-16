//
//  NewBluetoothManager.swift
//  SkySync
//
//  Created by Caleb Buening on 9/16/23.
//

import Foundation
import CoreBluetooth

class BluetoothManager: NSObject, CBCentralManagerDelegate, CBPeripheralManagerDelegate, CBPeripheralDelegate, ObservableObject {
    
    // Central Information
    private let serviceUUID = CBUUID(string: "F54BDA68-017A-4A83-A23D-76E2F1C20E1E")
    private var centralManager: CBCentralManager!
    @Published var discoveredPeripherals: [CBPeripheral] = []
    @Published var connectedPeripheral: CBPeripheral?
    var centralConnected = false
    
    // Peripheral information
    private let characteristicUUID = CBUUID(string: "F54BDA68-017A-4A83-A23D-76E2F1C20E1E")
    private var peripheralManager: CBPeripheralManager!
    private var readCallbacks: [(Data) -> Void] = []
    @Published var peripheralConnected = false
    
    // Initialize both the Central and Peripheral managers
    override init() {
        super.init()
        centralManager = CBCentralManager(delegate: self, queue: nil)
        peripheralManager = CBPeripheralManager(delegate: self, queue: nil)
        addReadCallback { data in
            print("Message Received")
        }
    }
    
    // MARK: Central //////////////////////////////////////////////////////////////////////
    
    func sendData(data: Data, to peripheral: CBPeripheral) {
        
        guard let characteristic = peripheral.services?.first(where: { $0.uuid == serviceUUID })?.characteristics?.first(where: { $0.uuid == characteristicUUID }) else {
            return
        }
        print("DEBUG: Data sent")
        peripheral.writeValue(data, for: characteristic, type: .withResponse)
        
    }

    
    // function to begin scanning
    func startScanning() {
        centralManager.scanForPeripherals(withServices: [serviceUUID], options: nil)
    }

    // function to stop scanning
    func stopScanning() {
        centralManager.stopScan()
    }
    
    // For choosing the peripheral to connect to
    func connect(to peripheral: CBPeripheral) {
        centralManager.connect(peripheral, options: nil)
    }

    // begin scanning when we can
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if central.state == .poweredOn {
            startScanning()
        }
    }

    // For handling new peripherals discovered
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        if !discoveredPeripherals.contains(where: { $0.identifier == peripheral.identifier }) {
            discoveredPeripherals.append(peripheral)
            print("DEBUG: Device found")
        }
    }

    // For handling one we're actually connected
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("DEBUG: Connected")
        connectedPeripheral = peripheral
        centralConnected = true
    }
    
    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        print(error)
    }
    
    // Peripheral Code /////////////////////////////
    
    // TODO: Potential error in the 3 functions below
    
    // Get information that is out there for us and store it
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        guard let services = peripheral.services else { return }
        for service in services {
            if service.uuid == serviceUUID {
                peripheral.discoverCharacteristics([characteristicUUID], for: service)
            }
        }
    }
    
    // Read any values in the discovered characteristics
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        guard let characteristics = service.characteristics else { return }
        for characteristic in characteristics {
            if characteristic.uuid == characteristicUUID {
                //peripheral.readValue(for: characteristic)
            }
        }
    }
    
    // Run the callbacks on any received data
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        if let data = characteristic.value {
            print(String(data: data, encoding: .utf8))
            for callback in readCallbacks {
                callback(data)
            }
        }
    }

    // Advertise our service as writable
    func startAdvertising() {
        let service = CBMutableService(type: serviceUUID, primary: true)
    
        // Allow the characteristic to be written to by a Central
        let characteristic = CBMutableCharacteristic(type: characteristicUUID,
                                                     properties: [.read, .write, .notify],
                                                     value: nil,
                                                     permissions: [.readable, .writeable])
    
        service.characteristics = [characteristic]
        peripheralManager.add(service)
        
        peripheralManager.startAdvertising([CBAdvertisementDataLocalNameKey: "Your Device Name",
                                            CBAdvertisementDataServiceUUIDsKey: [serviceUUID]])
    }
    
    func stopAdvertising() {
        peripheralManager.stopAdvertising()
    }
    
    // Get the thing going
    func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
        startAdvertising()
    }
    
    // When connection received
    func peripheralManager(_ peripheral: CBPeripheralManager, central: CBCentral, didSubscribeTo characteristic: CBCharacteristic) {
        print("DEBUG: Peripheral has received: \(central.identifier)'s subscription to \(characteristic.uuid)")
    }
    
    // When connection lost
    func peripheralManager(_ peripheral: CBPeripheralManager, central: CBCentral, didUnsubscribeFrom characteristic: CBCharacteristic) {
        print("DEBUG: Peripheral has lost \(central.identifier)'s subscription to \(characteristic.uuid)")
    }
    
    func peripheralManager(_ peripheral: CBPeripheralManager, didReceiveWrite request: CBATTRequest) {
        if let data = request.value, request.characteristic.uuid == characteristicUUID {
            print("DEBUG: Received data: \(String(data: data, encoding: .utf8) ?? "Unknown data")")
            
            for callback in readCallbacks {
                callback(data)
            }
            
            peripheralManager.respond(to: request, withResult: .success)
        }
    }
    
    func addReadCallback(callback: @escaping (Data) -> Void) {
        readCallbacks.append(callback)
    }
}
