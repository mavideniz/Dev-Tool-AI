//
//  SettingsView.swift
//  Dev Tool AI
//
//  Created by Doğancan Mavideniz on 8.07.2023.
//

import SwiftUI

struct SettingsView: View {
    @State private var selectedPrefix = 0
    @State private var selectedOutput = "🇬🇧 English"
    var lang = ["🇬🇧 English", "🇹🇷 Turkish", "🇪🇸Spanish", "🇸🇦 Arabic"]

    @AppStorage("directory") var directory: String = ""
    @AppStorage("apiKey") var apiKey: String = ""


    var body: some View {
        VStack {
            VStack {
                Text("⚙️ Settings")
                    .font(.custom(FontConstants.titleFont, size: 20))
                Text("Configure your settings")
                    .font(.custom(FontConstants.titleFont, size: 16))
                    .foregroundColor(.white.opacity(0.6))
            }

            VStack {
                Text("⚠️ Please enter your API KEY Before Using the Application!")
                    .font(.custom(FontConstants.titleFont, size: 15))
                    .multilineTextAlignment(.center)
                HStack {

                    Text("API Key:")
                        .font(.custom(FontConstants.messageFont, size: 16))

                    TextField("Enter your API key", text: $apiKey)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }
                    .padding(.top, 16)
                Button(action: {
                    saveAPIKey()
                }) {
                    Text("Save")
                        .cornerRadius(10)
                }
                VStack(alignment: .leading) {
                    Text("Select the commit messages prefix:")
                        .padding(.top, 16)
                        .font(.custom(FontConstants.messageFont, size: 16))

                    Picker("", selection: $selectedPrefix) {
                        Text("Emoji").tag(0)
                        Text("Text").tag(1)
                        Text("Number").tag(2)
                        Text("None").tag(3)
                    }

                        .pickerStyle(.segmented)
                        .padding(.bottom, 16)
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
                    Text("Select the output messages:")
                        .padding(.top, 16)
                        .font(.custom(FontConstants.messageFont, size: 16))

                    Picker("", selection: $selectedOutput) {
                        ForEach(lang, id: \.self) {
                            Text($0)
                        }

                    }.pickerStyle(.segmented)
                        .onChange(of: selectedOutput) { newValue in
                        UserDefaults.standard.set(newValue, forKey: "output")
                        print(UserDefaults.standard.string(forKey: "output"))
                    }
                        .padding(.bottom, 16)
                    HStack {
                        Text("Project Path:")
                            .font(.custom(FontConstants.messageFont, size: 16))
                        TextField("Steve/Developer/Project", text: $directory, onCommit: {
                            UserDefaults.standard.set(directory, forKey: "directory")
                        })
                            .font(.system(size: 12))
                            .padding(5)
                            .cornerRadius(10)
                        Spacer()
                    }
                }
            }.padding()
        }
    }
    func saveAPIKey() {
        UserDefaults.standard.set(apiKey, forKey: "apiKey")
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
