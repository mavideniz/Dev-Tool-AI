//
//  ChatAppViewModel.swift
//  Dev Tool AI
//
//  Created by Doğancan Mavideniz on 8.07.2023.
//

import Foundation

class ChatAppViewModel: ObservableObject {
    @Published var messages: [Message] = []
    @Published var currentInput: String = ""
    private let openAIService = OpenAiService()

    func sendMessage() {
        let newMessage = Message(id: UUID(), role: .user, content: currentInput, createAt: Date())
        messages.append(newMessage)
        currentInput = ""

        Task {
            let response = await openAIService.sendMessage(messages: messages)

            guard let receivedOpenAIMessage = response?.choices.first?.message else {
                print("Had no received message")
                let dummyMessage = Message(id: UUID(), role: .assistant, content: "I'm sorry, I couldn't generate a response at the moment.", createAt: Date())
                await MainActor.run {
                    messages.append(dummyMessage)
                }
                return
            }

            let receivedMessage = Message(id: UUID(), role: receivedOpenAIMessage.role, content: receivedOpenAIMessage.content, createAt: Date())

            await MainActor.run {
                messages.append(receivedMessage)
            }
        }
    }

    init() {
        let initialPrompt = """
            As a act senior software developer,
            """
        
        // TODO: Debug -- I'm encountering an error in my code in swift. Can you please help me troubleshoot and find a solution? Here's the error message I'm getting:
        let systemMessage = Message(id: UUID(), role: .system, content: initialPrompt, createAt: Date())
        messages.append(systemMessage)
    }
}

