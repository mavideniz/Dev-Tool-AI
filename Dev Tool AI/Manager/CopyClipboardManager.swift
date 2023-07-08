//
//  CopyClipboardManager.swift
//  Dev Tool AI
//
//  Created by Giray on 8.07.2023.
//

import AppKit

final class CopyClipboardManager {

    static let shared = CopyClipboardManager()

    private let pasteboard = NSPasteboard.general

    public func copyToClipboard(string: String) {
        pasteboard.clearContents()
        pasteboard.setString("\(string)", forType: .string)
    }

    public func clearClipboard() {
        pasteboard.clearContents()
    }
}
