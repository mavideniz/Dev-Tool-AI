//
//  ChatAppView.swift
//  Dev Tool AI
//
//  Created by Doğancan Mavideniz on 8.07.2023.
//

import SwiftUI

struct Message: Identifiable {
    let id = UUID()
    let content: String
    let isSentByUser: Bool
}

struct ChatAppView: View {
    @State private var messages: [Message] = []
    @State private var newMessage: String = ""
    
    var body: some View {
        VStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 8) {
                    ForEach(messages) { message in
                        Text(message.content)
                            .padding(8)
                            .background(message.isSentByUser ? Color.blue : Color.gray)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                }
            }.padding(.top)
            
            HStack {
                TextField("Mesajınızı yazın", text: $newMessage)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                Button(action: sendMessage) {
                    Text("Gönder")
                }
            }
            .padding()
        }
    }
    
    func sendMessage() {
        guard !newMessage.isEmpty else { return }
        
        messages.append(Message(content: newMessage, isSentByUser: true))
        // Burada API çağrısı yaparak gelen mesajı alabilirsiniz.
        
        newMessage = ""
    }
}



struct ChatAppView_Previews: PreviewProvider {
    static var previews: some View {
        ChatAppView()
    }
}
