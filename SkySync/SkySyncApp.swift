//
//  SkySyncApp.swift
//  SkySync
//
//  Created by Krish Shah on 9/16/23.
//

import SwiftUI
import CoreBluetooth

struct ConnectScreen: View {
    @ObservedObject var bluetoothManager: BluetoothManager
    @State var selectedPeripheral: CBPeripheral?
    @State var isConnected: Bool = false

    var body: some View {
        VStack(spacing: 20) {
            Text("Connect")
                .font(.largeTitle)
                .padding(.top)

            // List the discovered peripherals
            List(bluetoothManager.discoveredPeripherals, id: \.identifier) { peripheral in
                Button(action: {
                    bluetoothManager.connect(to: peripheral)
                    // For now, assuming a successful connection.
//                    isConnected = true
//                    selectedPeripheral = peripheral
                }) {
                    Text("\(peripheral.name ?? "Unknown") - \(UIDevice.current.name)")
                }
            }

            Spacer()
        }
        .padding()
        .sheet(isPresented: $bluetoothManager.isConnected) {
            ChatScreen(bluetoothManager: bluetoothManager)
        }
    }
}

struct ChatScreen: View {
    @ObservedObject var bluetoothManager: BluetoothManager

    var body: some View {
        VStack {
            Text("Chat with \(bluetoothManager.connectedPeripheral?.name ?? "unknown")")
            // Implement the chat interface here
            
            Button("click to send") {
                if let connectedPeripheral = bluetoothManager.connectedPeripheral {
                    if let data = "you are \(String(describing: connectedPeripheral.name))".data(using: .utf8) {
                        bluetoothManager.sendData(data: data, to: connectedPeripheral)
                    }
                }
            }
        }
    }
}

struct TitleScreen: View {
    @AppStorage("username") private var userName: String = ""

    var body: some View {
        VStack(spacing: 20) {
            Text("SkySync")
                .font(.largeTitle)
                .padding(.top)

            TextField("Enter your name", text: $userName)
                .padding(10)
                .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.gray, lineWidth: 1))
            
            Spacer()
        }
        .padding()
    }
}

@main
struct SkySyncApp: App {
    @ObservedObject var bluetoothManager = BluetoothManager()
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                VStack {
                    TitleScreen()
                    NavigationLink(destination: ConnectScreen(bluetoothManager: bluetoothManager)) {
                        Text("Chat")
                            .frame(minWidth: 200)
                            .padding(10)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                }
            }
        }
    }
}
