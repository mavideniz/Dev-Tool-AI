//
//  DebugSolutionViewModel.swift
//  Dev Tool AI
//
//  Created by Doğancan Mavideniz on 8.07.2023.
//

import Foundation

class DebugSolutionViewModel: ObservableObject {
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
            You are a developer working on a project and you need to create a clear and concise commit message for a new code change you made. Write a commit message that effectively communicates the purpose of your code change. Remember to follow best practices for writing commit messages, including providing a brief summary and, if necessary, additional details about the changes made. Put an appropriate prefix like [bug-fix], [feature] at the beginning of the commit message. In Turkish.
            """
        // Put an appropriate emoji at the beginning of the commit message.
        // Put an appropriate prefix like [bug-fix], [feature] at the beginning of the commit message.
        
        // In Turkish
        // In Arabic
        // In English
        let systemMessage = Message(id: UUID(), role: .system, content: initialPrompt, createAt: Date())
        messages.append(systemMessage)
    }
}
