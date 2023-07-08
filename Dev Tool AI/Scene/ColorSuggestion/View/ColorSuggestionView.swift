//
//  ColorSuggestionView.swift
//  Dev Tool AI
//
//  Created by Doğancan Mavideniz on 8.07.2023.
//

import SwiftUI

struct ColorModel {
    let name: String
    let hexColor: String
}

struct ColorSuggestionView: View {

    @State private var shouldShowSuccessView: Bool = false

    @State private var searchResultKeyword: String = ""

    @State private var keywordText: String = ""

    let colorResponses: [ColorModel] = [
            .init(name: "Blue", hexColor: "#F0F8FF"),
            .init(name: "Coral", hexColor: "#FF7F50"),
            .init(name: "Fire", hexColor: "#B22222"),
            .init(name: "Hot Pink", hexColor: "#FF69B4"),
    ]

    var body: some View {
        ZStack {
            Color.clear.edgesIgnoringSafeArea(.all)
            VStack(spacing: 10) {
                TextField("Keyword", text: $keywordText)
                    .textFieldStyle(.plain)
                    .padding(15)
                    .background(Color(hex: "#767a82"))
                    .cornerRadius(10)
                    .padding(.horizontal, 40)


                if searchResultKeyword != "" && colorResponses.count > 1 {
                    Text("\(searchResultKeyword)")
                        .italic()

                    HStack {
                        ForEach(0..<colorResponses.count, id: \.self) { index in
                            VStack(spacing: 2) {
                                Rectangle()
                                    .foregroundColor(Color(hex: "\(colorResponses[index].hexColor)"))
                                    .frame(height: 100)
                                    .cornerRadius(15)

                                Text("\(colorResponses[index].name)")
                                    .foregroundColor(.white)
                                    .font(.system(size: 13, weight: .bold))
                                    .multilineTextAlignment(.center)
                                    .padding(.top, 7)

                                Text("\(colorResponses[index].hexColor)")
                                    .foregroundColor(.white)
                                    .font(.system(size: 12))
                                    .multilineTextAlignment(.center)
                            }.padding(5)
                                .padding(.bottom, 7)
                                .background(Color.black.opacity(0.1))
                                .cornerRadius(15)
                                .onTapGesture {
                                shouldShowSuccessView = true
                                CopyClipboardManager.shared.copyToClipboard(string: "\(colorResponses[index].hexColor)")
                            }
                        }
                    }.padding(.horizontal, 5)
                }

                Button {
                    searchResultKeyword = keywordText
                } label: {
                    HStack(spacing: 10) {
                        Text(searchResultKeyword == "" ? "Generate" : "Regenerate")
                            .font(.system(size: 15, weight: .bold))
                            .foregroundColor(.white)

                        Image(systemName: "chevron.right")
                            .foregroundColor(.white)
                            .scaledToFit()
                            .frame(width: 30, height: 30)
                    }.padding()
                        .background(Color.black.opacity(0.7))
                        .cornerRadius(15)
                    
                }.buttonStyle(.plain)
            }
            
            if shouldShowSuccessView {
                SuccessMessagePopUpView(shouldShow: $shouldShowSuccessView, text: "Hex color copied!")
            }
            
        }
    }
}
