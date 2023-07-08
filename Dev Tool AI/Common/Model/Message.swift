//
//  Message.swift
//  Dev Tool AI
//
//  Created by Mehmet Ali Demir on 8.07.2023.
//

import Foundation

struct Message: Equatable {
    let id: UUID
    let role: SenderRole
    let content: String
    let createAt: Date
    var language: String?
}
