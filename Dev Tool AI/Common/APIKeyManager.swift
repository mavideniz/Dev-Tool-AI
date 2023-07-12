//
//  APIKeyManager.swift
//  Dev Tool AI
//
//  Created by Mehmet Ali Demir on 11.07.2023.
//

import Foundation

struct APIKeyManager {
    static var apiKey: String {
        get {
            return SettingsView().apiKey
        }
        set {
            SettingsView().apiKey = newValue
        }
    }
}
