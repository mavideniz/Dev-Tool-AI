//
//  GitHubStatusManager.swift
//  Dev Tool AI
//
//  Created by Giray on 8.07.2023.
//

import SwiftUI

class GitHubStatusManager: ObservableObject {

    @Published var commitSummary: String = ""
    private let openAIService = OpenAiService()
    @AppStorage("directory") var directory: String = ""
    @Published var changedFiles: [String] = []

    @Published var isLoading: Bool = false

    func getFiles() -> [String]? {
        let task = Process()
        let pipe = Pipe()

        task.launchPath = "/usr/bin/env" // Path to the Git executable
        // /Users/giray/Documents/GitHub/Dev-Tool-AI
        task.currentDirectoryPath = directory

        task.arguments = ["git", "diff", "--minimal", "HEAD"] // Git command and arguments

        task.standardOutput = pipe
        task.launch()

        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        let output = String(data: data, encoding: .utf8)

        task.waitUntilExit()

        if task.terminationStatus == 0, let fileNames = output?.components(separatedBy: .newlines) {
            return fileNames
        } else {
            return nil
        }
    }

    func getChangedFiles() {
        let task = Process()
        let pipe = Pipe()

        task.launchPath = "/usr/bin/env" // Path to the Git executable
        task.currentDirectoryPath = directory // Path to your Git repository

        task.arguments = ["git", "diff", "--name-only", "HEAD"] // Git command and arguments

        task.standardOutput = pipe
        task.launch()

        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        let output = String(data: data, encoding: .utf8)

        task.waitUntilExit()

        if task.terminationStatus == 0, let fileNames = output?.components(separatedBy: .newlines) {
            self.changedFiles = fileNames
        }
    }

    func findChangedFilesDecription() -> String {
        var longString = ""

        if let files = self.getFiles() {
            for file in files {
                longString += file
            }
        }
        return longString
    }

    func sendMessage(language: String, prefix: String) {
        self.isLoading = true
        self.commitSummary.removeAll()

        let newMessage = Message(id: UUID(), role: .user, content: """
            Analyze the code at the end of the sentence and provide me with the short commit message. Omit any descriptions or comments related to the code with bullet points. Translate to \(language) language. \(prefix). Here's the code:
            \(self.findChangedFilesDecription())
            """, createAt: Date())

        Task {
            let response = await openAIService.sendMessage(messages: [newMessage])
            guard let receivedOpenAIMessage = response?.choices.first?.message else {
                self.isLoading = false
                return
            }
            let receivedMessage = Message(id: UUID(), role: .system, content: receivedOpenAIMessage.content, createAt: Date())

            await MainActor.run {
                self.commitSummary = receivedMessage.content
                self.isLoading = false
            }
        }
    }

}
