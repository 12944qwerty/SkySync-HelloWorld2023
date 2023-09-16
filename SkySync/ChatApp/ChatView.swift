//
//  ChatView.swift
//  SkySync
//
//  Created by Krish Shah on 9/16/23.
//

import SwiftUI

struct ChatView: View {
    @AppStorage("username") var username: String = ""
    @State var messages: [String: [Message]]
    
    @State var withUser: String
    var body: some View {
        VStack {
            ScrollView {
                VStack(spacing: 0) {
                    ForEach(messages[withUser] ?? [Message](), id: \.self) { message in
                        let isSameAuthor = messages[withUser]?.after(message)?.author == message.author
                        
                        MessageBubble(username: username, author: message.author, message: message.message)
                            .padding(.bottom, isSameAuthor ? 5 : 15)
    }
}
            }

        }
        }
        }
        .navigationTitle(Text(withUser + " vs " + username))
    }
}

struct Message: Hashable {
    var author: String
    var message: String
}

struct ChatView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
//            NavigationLink("hi") {
                ChatView(messages: [
                    "Rick": [
                        Message(author: "Krish", message: "Hello!!"),
                        Message(author: "Rick",
                                message: "Hello there!"),
                        Message(author: "Rick", message: "How are you!")
                    ]
                ], withUser: "Rick")
//            }
        }
    }
}
