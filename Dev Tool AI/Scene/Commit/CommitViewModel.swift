//
//  CommitViewModel.swift
//  Dev Tool AI
//
//  Created by Mehmet Ali Demir on 8.07.2023.
//

import Foundation

class CommitViewModel: ObservableObject {
    @Published var messages: [Message] = []
    @Published var currentInput: String = ""
    private let openAIService = OpenAiService()
    
    @Published var isLoading: Bool = false

    func sendMessage(prefix: String, output: String) {
        isLoading = true
        self.messages.removeAll()
        
        let initialPrompt = """
            You are a developer working on a project and you need to create a clear and concise commit message for a new code change you made. Write a commit message that effectively communicates the purpose of your code change. Remember to follow best practices for writing commit messages, including providing a brief summary and, if necessary, additional details about the changes made. \(prefix). Give the next answers in \(output).
            """
        let systemMessage = Message(id: UUID(), role: .system, content: initialPrompt, createAt: Date())
        messages.append(systemMessage)
        
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
                isLoading = false
                return
            }

            let receivedMessage = Message(id: UUID(), role: receivedOpenAIMessage.role, content: receivedOpenAIMessage.content, createAt: Date())

            await MainActor.run {
                messages.append(receivedMessage)
                isLoading = false
            }
        }
    }
}

