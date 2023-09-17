//
//  ContentView.swift
//  SkySync
//
//  Created by Krish Shah on 9/16/23.
//

import SwiftUI

struct ContentView: View {    
    @EnvironmentObject var bluetoothManager: BluetoothManager
    
    var body: some View {
        NavigationView {
            VStack {
                VStack(spacing: 20) {
                    Text("SkySync")
                        .font(.largeTitle)
                        .padding(.top)
                    
                    Spacer()
                }
                .padding()
                
                NavigationLink {
                    if bluetoothManager.isConnected {
                        ChatView()
                    } else {
                        ConnectScreen()
                    }
                } label: {
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
    }
}
