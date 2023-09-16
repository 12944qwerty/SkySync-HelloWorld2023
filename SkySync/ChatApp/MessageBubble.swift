//
//  MessageBubble.swift
//  SkySync
//
//  Created by Krish Shah on 9/16/23.
//

import SwiftUI

enum Side {
    case left
    case right
}

struct MessageBubble: View {
    @State var author: String
    @State var message: String
    
    @State var side: Side = .left
    
    var body: some View {
        HStack {
            if side == .right {
                Spacer()
            }
            
            Spacer().frame(maxWidth: 10)
            
            Rectangle()
                .foregroundColor(Color.green)
                .cornerRadius(10)
                .frame(width: 200, height: 50)
                .overlay(
                    VStack {
                        Text(author)
                            .font(.headline)
                            .foregroundColor(.white)
                        Text(message)
                            .font(.body)
                            .foregroundColor(.white)
                    }
                )
            
            Spacer().frame(maxWidth: 10)
            
            if side == .left {
                Spacer()
            }
        }
    }
}

struct MessageBubble_Previews: PreviewProvider {
    static var previews: some View {
        MessageBubble(author: "Krish", message: "Omg HIII")
    }
}
