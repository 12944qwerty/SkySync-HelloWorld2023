//
//  ConnectView.swift
//  SkySync
//
//  Created by Krish Shah on 9/16/23.
//

import SwiftUI
import Foundation

struct ConnectScreen: View {
    @EnvironmentObject var bluetoothManager: BluetoothManager
    
    @State var selected: [UUID: Bool] = [:]

    var body: some View {
        VStack(spacing: 20) {
            // List the discovered peripherals
            List(bluetoothManager.discoveredPeripherals, id: \.identifier) { peripheral in
                Button(peripheral.name ?? "Unknown") {
                    bluetoothManager.connectedPeripheral = peripheral
                    bluetoothManager.isConnected = true
                }
            }

            Spacer()
        }
        .padding()
        .navigationTitle("Connect")
    }
}
