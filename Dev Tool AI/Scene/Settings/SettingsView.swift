//
//  SettingsView.swift
//  Dev Tool AI
//
//  Created by Doğancan Mavideniz on 8.07.2023.
//

import SwiftUI

struct SettingsView: View {
    @State private var selectedPrefix = 0
    @State private var selectedOutput = 0
    var body: some View {
        ZStack {
            VStack {
                Text("Select the commit messages prefix")
                Picker("", selection: $selectedPrefix) {
                    Text("Emoji").tag(0)
                    Text("Text").tag(1)
                    Text("None").tag(2)
                }.pickerStyle(.segmented)
                    .padding(.bottom, 8)
                Text("Select the output messages")
                Picker("", selection: $selectedOutput) {
                    Text("English").tag(0)
                    Text("Turkish").tag(1)
                    Text("Arabic").tag(2)
                }.pickerStyle(.segmented)
            }.padding()
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
