//
//  SkySyncApp.swift
//  SkySync
//
//  Created by Krish Shah on 9/16/23.
//

import SwiftUI
import CoreBluetooth

struct ConnectScreen: View {
    @EnvironmentObject var bluetoothManager: BluetoothManager

    var body: some View {
        VStack(spacing: 20) {
            // List the discovered peripherals
            List(bluetoothManager.discoveredPeripherals, id: \.identifier) { peripheral in
                Button(action: {
                    bluetoothManager.isConnected = true
                    bluetoothManager.connectedPeripheral = peripheral
                }) {
                    Text("\(bluetoothManager.discoveredNames[peripheral.identifier] ?? "unknown") - \(peripheral.name ?? "Unknown")")
                }
            }

            Spacer()
        }
        .padding()
        .sheet(isPresented: $bluetoothManager.isConnected) {
            ChatScreen()
        }
        .navigationTitle("Connect")
    }
}

struct ChatScreen: View {
    @EnvironmentObject var bluetoothManager: BluetoothManager

    var body: some View {
        VStack {
            Text("Chatting with \(bluetoothManager.discoveredNames[bluetoothManager.connectedPeripheral!.identifier] ?? "unknown")")
            // Implement the chat interface here
            
            Button("click to send") {
                if let connectedPeripheral = bluetoothManager.connectedPeripheral {
                    print("clicked send")
                    bluetoothManager.sendMessage("you are \(String(describing: connectedPeripheral.name)) \(Int.random(in: 1...100))", to: connectedPeripheral)
                }
            }
        }
    }
}

@main
struct SkySyncApp: App {
    @AppStorage("username") var userName: String = ""
    
    @ObservedObject var bluetoothManager: BluetoothManager
    
    init() {
        bluetoothManager = BluetoothManager(UserDefaults.standard.string(forKey: "username") ?? "")
    }
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                VStack {
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
                    
                    NavigationLink(destination: ConnectScreen()) {
                        Text("Chat")
                            .frame(minWidth: 200)
                            .padding(10)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                }
                .padding()
            }
            .environmentObject(bluetoothManager)
        }
    }
}
