//
//  ChatView.swift
//  SkySync
//
//  Created by Krish Shah on 9/16/23.
//

import SwiftUI

struct ChatView: View {
    @EnvironmentObject var bluetoothManager: BluetoothManager
    
    @State var messages: [Message] = []
    
    @State var newMessage = ""
    
    func sendMessage() {
        if newMessage.count > 0 {
            let message = Message(author: UIDevice.current.identifierForVendor!.uuidString, message: newMessage)
            messages.append(message)
            
            if let connectedPeripheral = bluetoothManager.connectedPeripheral {
                bluetoothManager.sendMessage("chatapp|:|\(UIDevice.current.identifierForVendor!.uuidString)|:|\(newMessage)", to: connectedPeripheral)
            }
            newMessage = ""
        }
    }
    
    var body: some View {
        VStack {
            ScrollView {
                VStack(spacing: 0) {
                    ForEach(messages, id: \.self) { message in
                        let isSameAuthor = messages.after(message)?.author == message.author
                        
                        MessageBubble(author: message.author, message: message.message)
                            .padding(.bottom, isSameAuthor ? 5 : 15)
                    }
                }
            }
            
            HStack {
                TextField("Message", text: $newMessage)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal, 10)
                    .submitLabel(.send)
                    .onSubmit(sendMessage)
                
                Button(action: sendMessage) {
                    Label("", systemImage: "paperplane.fill")
                }
            }
            .padding(.horizontal, 10)
        }
        .onAppear {
            bluetoothManager.addReadCallback(id: "chatapp") { data in
                let message = String(data: data, encoding: .utf8)!
                
                if String(message.split(separator: "|:|")[0]) != "chatapp" {
                    return
                }
                
                let author = String(message.split(separator: "|:|")[1])
                let msg = String(message.split(separator: "|:|")[2])
                
                self.messages.append(Message(author: author, message: msg))
            }
        }
        .navigationTitle(Text(bluetoothManager.connectedPeripheral?.name ?? "unknown"))
    }
}

struct Message: Hashable {
    var author: String
    var message: String
}
