//
//  AutoCommitView.swift
//  Dev Tool AI
//
//  Created by Mehmet Ali Demir on 8.07.2023.
//

import SwiftUI

struct AutoCommitView: View {
    @EnvironmentObject var githubStatusManager: GitHubStatusManager
    @EnvironmentObject var languageManager: LanguageManager

    @State private var shouldShowSuccessView: Bool = false

    @State private var didTapEditButton: Bool = false

    var body: some View {
        ZStack(alignment: .top) {
            Color.clear.edgesIgnoringSafeArea(.all)
            HStack {
                VStack() {
                    Text("👋🏻 Auto Commit Bot")
                        .font(.custom(FontConstants.titleFont, size: 20))
                        .padding(.top)
                    Text("Generate an auto commit")
                        .font(.custom(FontConstants.titleFont, size: 16))
                        .foregroundColor(.white.opacity(0.6))


                    if githubStatusManager.commitSummary != "" {
                        HStack {
                            if didTapEditButton {
                                TextField("", text: $githubStatusManager.commitSummary, axis: .vertical)
                                    .textFieldStyle(.plain)
                                    .multilineTextAlignment(.center)
                                    .foregroundColor(.white)
                            } else {
                                Text("\(githubStatusManager.commitSummary)")
                                    .multilineTextAlignment(.leading)
                                    .foregroundColor(.white)
                            }

                            Spacer()

                            VStack(spacing: 10) {
                                Button {
                                    githubStatusManager.sendMessage(language: languageManager.outputLanguage, prefix: languageManager.prefixLanguage)
                                } label: {
                                    Image(systemName: "arrow.clockwise")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 20, height: 20)
                                        .foregroundColor(.blue)
                                        .padding(8)
                                        .background(Color.white)
                                        .cornerRadius(30)
                                }.buttonStyle(.plain)

                                Button {
                                    self.didTapEditButton.toggle()
                                } label: {
                                    Image(systemName: self.didTapEditButton ? "checkmark" : "pencil")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 20, height: 20)
                                        .foregroundColor(.blue)
                                        .padding(10)
                                        .background(Color.white)
                                        .cornerRadius(15)
                                }.buttonStyle(.plain)
                            }
                        }.padding(.top, -5)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color(hex: ColorConstants.secondColor)?.opacity(0.7))
                            .cornerRadius(15)
                            .padding(.horizontal, 20)
                    }

                    if githubStatusManager.commitSummary == "" && !githubStatusManager.isLoading {
                        Button {
                            self.githubStatusManager.sendMessage(language: languageManager.outputLanguage, prefix: languageManager.prefixLanguage)
                        } label: {
                            HStack() {
                                Text("Commit Generate")
                                    .font(.custom(FontConstants.messageFont, size: 16))
                                    .foregroundColor(.white)
                                Image(systemName: "chevron.right")
                                    .foregroundColor(.white)
                                    .scaledToFit()
                            }.frame(width: 150)
                                .padding(.horizontal, 20)
                                .padding(.vertical, 15)
                                .background(Color(hex: ColorConstants.secondColor))
                                .cornerRadius(15)
                        }.buttonStyle(.plain)
                            .frame(maxHeight: .infinity, alignment: .center)

                    }
                    else {
                        if !githubStatusManager.isLoading {
                            Button {
                                CopyClipboardManager.shared.copyToClipboard(string: githubStatusManager.commitSummary)
                                self.shouldShowSuccessView = true
                            } label: {
                                HStack() {
                                    Text("Copy the commit")
                                        .foregroundColor(.blue)
                                        .font(.system(size: 15, weight: .bold))
                                }.frame(width: 150)
                                    .padding(.horizontal, 15)
                                    .padding(.vertical, 10)
                                    .background(.white)
                                    .cornerRadius(15)
                                    .padding(.bottom, 15)
                            }.buttonStyle(.plain)
                        }
                    }
                    if githubStatusManager.isLoading {
                        ProgressView()
                    } else {
                        VStack(alignment: .leading, spacing: 4) {
                            Spacer()
                            VStack(alignment: .leading, spacing: 5) {
                                Text("Changed Files:")
                                    .foregroundColor(.white)
                                    .font(.custom(FontConstants.messageFont, size: 16))
                                    .padding(.bottom, 15)

                                ForEach(0..<githubStatusManager.changedFiles.count, id: \.self) { index in
                                    Text("- \(githubStatusManager.changedFiles[index])")
                                        .foregroundColor(.white.opacity(0.8))
                                        .font(.custom(FontConstants.messageFont, size: 15))
                                }
                            }.padding()
                                .background(Color.init(hex: ColorConstants.mainColor)?.opacity(0.7))
                                .cornerRadius(15)
                        }.padding(.horizontal, 15)
                            .padding(.bottom, 15)
                    }

                }
            }.onAppear {
                githubStatusManager.getChangedFiles()
            }
            if shouldShowSuccessView {
                SuccessMessagePopUpView(shouldShow: $shouldShowSuccessView, text: "Copied to clipboard")
            }
        }
    }
}
