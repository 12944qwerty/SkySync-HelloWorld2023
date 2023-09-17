//
//  SkySyncApp.swift
//  SkySync
//
//  Created by Krish Shah on 9/16/23.
//

import SwiftUI

@main
struct SkySyncApp: App {    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(BluetoothManager())
        }
    }
}
