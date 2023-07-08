//
//  Dev_Tool_AIApp.swift
//  Dev Tool AI
//
//  Created by Doğancan Mavideniz on 8.07.2023.
//

import SwiftUI

@main
struct Dev_Tool_AIApp: App {
    var body: some Scene {
        MenuBarExtra("UtilityApp", systemImage: "hammer") {
            MainView()
//            Button("Quit") {
//                NSApplication.shared.terminate(nil)
//            }.keyboardShortcut("q").padding(.bottom, 12)
        }.menuBarExtraStyle(.window)

    }
}
