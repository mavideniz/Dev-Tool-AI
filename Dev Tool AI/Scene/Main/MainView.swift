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
                Label("Menu", systemImage: "list.dash")
            }
            ColorSuggestionView()
                .tabItem {
                Label("Color", systemImage: "square.and.pencil")
            }
            
        }.padding().frame(width: 400, height: 400)

    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
