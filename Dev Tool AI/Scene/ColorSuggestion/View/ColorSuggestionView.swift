//
//  ColorSuggestionView.swift
//  Dev Tool AI
//
//  Created by Doğancan Mavideniz on 8.07.2023.
//

import SwiftUI

struct ColorSuggestionView: View {

    @StateObject private var viewModel = ColorSuggestionViewModel()

    @State private var shouldShowSuccessView: Bool = false
    @State private var searchResultKeyword: String = ""
    @State private var keywordText: String = ""

    var body: some View {
        ZStack {
            Color.clear.edgesIgnoringSafeArea(.all)

            VStack {
                Text("🎨 Color Bot")
                    .font(.custom(FontConstants.titleFont, size: 20))

                Text("Generate a new palette")
                    .font(.custom(FontConstants.titleFont, size: 16))
                    .foregroundColor(.white.opacity(0.6))


                if self.viewModel.shouldShowError {
                    Text("No colors found. Try another keyword.")
                        .multilineTextAlignment(.center)
                        .foregroundColor(.white)
                }

                VStack(spacing: 10) {
                    if self.viewModel.shouldShowError {
                        Text("No colors found. Try another keyword.")
                            .multilineTextAlignment(.center)
                            .foregroundColor(.white)
                    }
                    ZStack {
                        TextField("Write your keyword", text: $keywordText)
                            .font(.system(size: 16))
                            .frame(width: 350)
                            .textFieldStyle(.plain)
                            .padding(15)
                            .background(Color(hex: "#767a82"))
                            .cornerRadius(10)
                            .padding(.horizontal, 40)
                        HStack {
                            Spacer()
                            if self.viewModel.isLoading {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle())
                                    .controlSize(.small)
                                    .padding(.trailing, 60)
                            }
                        }
                        
                    }
                    
                    if searchResultKeyword != "" && viewModel.colorResponses.count > 1 {
                        HStack {
                            ForEach(0..<viewModel.colorResponses.count, id: \.self) { index in
                                VStack(spacing: 2) {
                                    Rectangle()
                                        .foregroundColor(Color(hex: "\(viewModel.colorResponses[index].hexColor)"))
                                        .frame(height: 100)
                                        .cornerRadius(15)

                                    Text("\(viewModel.colorResponses[index].name)")
                                        .minimumScaleFactor(0.01)
                                        .foregroundColor(.white)
                                        .font(.system(size: 13, weight: .bold))
                                        .multilineTextAlignment(.center)
                                        .padding(.top, 7)

                                    Text("\(viewModel.colorResponses[index].hexColor)")
                                        .foregroundColor(.white)
                                        .font(.system(size: 12))
                                        .multilineTextAlignment(.center)
                                }.frame(height: 150)
                                    .padding(5)
                                    .padding(.bottom, 7)
                                    .background(Color.black.opacity(0.1))
                                    .cornerRadius(15)
                                    .onTapGesture {
                                    shouldShowSuccessView = true
                                    CopyClipboardManager.shared.copyToClipboard(string: "\(viewModel.colorResponses[index].hexColor)")
                                }
                            }.frame(height: 150)
                                .padding(5)
                                .padding(.bottom, 7)
                                .background(Color.black.opacity(0.1))
                                .cornerRadius(15)

                        }.padding(.horizontal, 40)
                    }

                    Button {
                        searchResultKeyword = keywordText
                        self.viewModel.keyword = searchResultKeyword
                        viewModel.sendMessage()
                    } label: {
                        HStack() {
                            Text(searchResultKeyword == "" ? "Generate" : "Regenerate")
                                .font(.system(size: 15, weight: .bold))
                                .foregroundColor(.white)
                            Image(systemName: "chevron.right")
                                .foregroundColor(.white)
                                .scaledToFit()
                        }.frame(width: 150)
                            .padding(.horizontal, 15)
                            .padding(.vertical, 10)
                            .background(Color(hex: ColorConstants.secondColor))
                            .cornerRadius(15)
                    }.buttonStyle(.plain)
                        .disabled(keywordText.count == 0)
                        .padding(.top, 8)
                }

                
            }
            
            if shouldShowSuccessView {
                SuccessMessagePopUpView(shouldShow: $shouldShowSuccessView, text: "Hex color copied!")
            }
        }
    }
}
