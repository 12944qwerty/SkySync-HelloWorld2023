// TicTacToeView.swift

import SwiftUI

@main
struct SkySyncApp: App {
    @ObservedObject var bluetoothManager = BluetoothManager()
    
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                VStack {
                    Connect4View()
                }
            }
        }
    }
}
