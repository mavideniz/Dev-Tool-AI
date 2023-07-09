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
            self.changedFiles.removeLast()
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
                        You are a developer working on a project and you need to create a clear and concise commit message for a new code change you made. Write a commit message that effectively communicates the purpose of your code change. Remember to follow best practices for writing commit messages, including providing a brief summary and, if necessary, additional details about the changes made. \(prefix). Give the next answers in \(language) Here's the code:
            \(self.findChangedFilesDecription())
            """, createAt: Date())
        
        
        print("---newMessage\(newMessage.content)")
        
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
