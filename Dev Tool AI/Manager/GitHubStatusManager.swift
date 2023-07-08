//
//  GitHubStatusManager.swift
//  Dev Tool AI
//
//  Created by Giray on 8.07.2023.
//

import Foundation

class GitHubStatusManager {
    static let shared = GitHubStatusManager()

    func getChangedFiles() -> [String]? {
        let task = Process()
        let pipe = Pipe()

        task.launchPath = "/usr/bin/env" // Path to the Git executable
        
        
        task.currentDirectoryPath = "/Users/giray/Documents/GitHub/Dev-Tool-AI" // Path to your Git repository
        
        task.arguments = ["git", "diff", "--name-only", "HEAD"] // Git command and arguments

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

}
