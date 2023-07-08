//
//  SettingsView.swift
//  Dev Tool AI
//
//  Created by Doğancan Mavideniz on 8.07.2023.
//

import SwiftUI

struct SettingsView: View {
    @State private var selectedPrefix = 0
    @State private var selectedOutput = "English"
    var lang = ["English", "Turkish", "Spanish", "Arabic"]
    @State private var directory: String = ""
    var body: some View {
        ZStack {
            VStack {
                Text("⚙️ Settings")
                    .font(.custom(FontConstants.titleFont, size: 20))
                    .padding(.top)
                Text("Configure your settings")
                    .font(.custom(FontConstants.titleFont, size: 16))
                    .foregroundColor(.white.opacity(0.6))
                Text("Select the commit messages prefix")
                    .padding(.top, 16)
                Picker("", selection: $selectedPrefix) {
                    Text("Emoji").tag(0)
                    Text("Text").tag(1)
                    Text("Number").tag(2)
                    Text("None").tag(3)
                }

                    .pickerStyle(.segmented)
                    .padding(.bottom, 8)
                    .onChange(of: selectedPrefix) { newValue in
                    // Perform an action based on the selected option
                    switch newValue {
                    case 0:
                        print("Option 1 selected")
                        UserDefaults.standard.set("With an appropriate emoji at the beginning of the commit message.", forKey: "prefix")
                        // Do something for Option 1
                    case 1:
                        print("Option 2 selected")
                        UserDefaults.standard.set("Put an appropriate prefix like [bug-fix], [feature] at the beginning of the commit message.", forKey: "prefix")
                        // Do something for Option 2
                    case 2:
                        print("Option 3 selected")
                        UserDefaults.standard.set("Put an appropriate prefix like [123] (which number user enter) at the beginning of the commit message.", forKey: "prefix")
                        // Do something for Option 3
                    case 3:
                        print("Option 4 selected")
                        UserDefaults.standard.set("", forKey: "prefix")
                    default:
                        break
                    }
                }
                Text("Select the output messages")
                    .padding(.top, 16)
                Picker("", selection: $selectedOutput) {
                    ForEach(lang, id: \.self) {
                        Text($0)
                    }
                }.pickerStyle(.segmented)
                    .onChange(of: selectedOutput) { newValue in
                    UserDefaults.standard.set(newValue, forKey: "output")
                    print(UserDefaults.standard.string(forKey: "output"))
                }
                Text("Select the output messages")
                    .padding(.top, 16)
                TextField("Steve/Developer/Project", text: $directory, onCommit: {
                    UserDefaults.standard.set(directory, forKey: "directory")
                })
                    .font(.system(size: 12))
                    .frame(width: 350)
                    .textFieldStyle(.plain)
                    .padding(5)
                    .background(Color(hex: "#767a82"))
                    .cornerRadius(10)
                    .padding(.horizontal, 40)
                
                Spacer()
            }.padding()
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
