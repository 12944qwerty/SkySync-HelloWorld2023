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
    
    var side: Side { UIDevice.current.identifierForVendor!.uuidString == author ? .right : .left
    }
    
    var body: some View {
        HStack {
            if side == .right {
                Spacer()
            }
            
            Text(message)
                .font(.body)
                .padding(.all, 10)
                .padding(.horizontal, 5)
                .foregroundColor(.white)
                .background(side == .right ? .orange : .purple)
                .clipShape(ChatBubbleShape(direction: side))
            
            if side == .left {
                Spacer()
            }
        }
        .padding((side == .left) ? .leading : .trailing, 20)
        .padding((side == .right) ? .leading : .trailing, 80)
    }
}

struct MessageBubble_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 15) {
            MessageBubble(author: "8F691855-6AA4-41DA-8F7D-446C940A6DC5", message: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Suspendisse ut semper quam. Phasellus non mauris sem. Donec sed fermentum eros. Donec pretium nec turpis a semper.")
            MessageBubble(author: "Rick Astley", message: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Suspendisse ut semper quam. Phasellus non mauris sem. Donec sed fermentum eros. Donec pretium nec turpis a semper.")
        }
    }
}
