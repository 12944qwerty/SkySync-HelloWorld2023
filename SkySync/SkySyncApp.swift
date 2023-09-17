//
//  SkySyncApp.swift
//  SkySync
//
//  Created by Krish Shah on 9/16/23.
//

import SwiftUI

@main
struct SkySyncApp: App {
    @AppStorage("username") var userName: String = ""
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(BluetoothManager(userName))
        }
    }
}
