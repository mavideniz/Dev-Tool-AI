//
//  ColorSuggestionViewModel.swift
//  Dev Tool AI
//
//  Created by Mehmet Ali Demir on 8.07.2023.
//

import Foundation

final class ColorSuggestionViewModel: ObservableObject {
    @Published var messages: [Message] = []
    private let openAIService = OpenAiService()

    @Published var keyword: String = ""

    @Published var colorResponses: [DesignModel] = []

    @Published var isLoading: Bool = false
    @Published var shouldShowError: Bool = false

    func sendMessage() {
        self.isLoading = true
        self.colorResponses.removeAll()
        let newMessage = Message(id: UUID(), role: .user, content: keyword, createAt: Date())
        messages.append(newMessage)
        keyword = ""

        Task {
            let response = await self.openAIService.sendMessage(messages: self.messages)

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
                var messages = receivedMessage.content
                messages.removeAll { element in
                    element == "-"
                }

                let dividedMessages = messages.split(separator: "\n")

                for colorModels in dividedMessages {
                    let dividedColors = colorModels.split(separator: ",")
                    let name = String(dividedColors[0])
                    if dividedColors.count > 2 {
                        var hexColor = String(dividedColors[2])
                        hexColor = hexColor.trimmingCharacters(in: .whitespaces)
                        print(hexColor)
                        let fontName = String(dividedColors[1])
                        let colorModel = DesignModel(name: name, hexColor: hexColor, fontName: fontName)
                        self.colorResponses.append(colorModel)
                    } else {
                        self.shouldShowError = true
                    }
                }

                self.isLoading = false
            }
        }
    }

    init() {
//        let initialPrompt = """
//            I will give a keyword and I want you to find me the related 4 different colors and give those colors in the following format. Make colors bullet list and give color name and then put , (comma) and write hex code of the color. Only give list as your answer, don't write anything else. ONLY THE COLORS. My keyword is
//            """

        let initialPrompt = """
I will give a keyword and I want you to find me the related 4 different colors and fonts, give those in the following format; put - (dash) at the start of the line, write color name and then put , (comma) and write font name and put , (comma) and write hex code of the color in the same line and then move to the next line. Only give list as your answer, don't write anything else. My keyword is
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
