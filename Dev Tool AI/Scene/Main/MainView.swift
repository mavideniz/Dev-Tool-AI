//
//  MainView.swift
//  Dev Tool AI
//
//  Created by Doğancan Mavideniz on 8.07.2023.
//

import SwiftUI

struct MainView: View {
    var body: some View {
        TabView {
            ChatAppView()
                .tabItem {
                    Label("Chat", systemImage: "list.dash")
            }
            CommitView()
                .tabItem {
                Label("Commit", systemImage: "square.and.pencil")
            }
            DebugSolutionView()
                .tabItem {
                Label("Debug", systemImage: "list.dash")
            }
            ColorSuggestionView()
                .tabItem {
                Label("Color", systemImage: "square.and.pencil")
            }
            SettingsView()
                .tabItem {
                Label("Settings", systemImage: "gear")
            }
        }.padding().frame(width: 500, height: 600)

    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
