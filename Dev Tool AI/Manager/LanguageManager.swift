//
//  LanguageManager.swift
//  Dev Tool AI
//
//  Created by Mehmet Ali Demir on 8.07.2023.
//

import SwiftUI

class LanguageManager: ObservableObject {
    @AppStorage("output") var outputLanguage: String = ""
    @AppStorage("prefix") var prefixLanguage: String = ""
}
