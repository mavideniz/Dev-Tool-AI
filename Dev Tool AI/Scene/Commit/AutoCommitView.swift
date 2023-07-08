//
//  AutoCommitView.swift
//  Dev Tool AI
//
//  Created by Mehmet Ali Demir on 8.07.2023.
//

import SwiftUI

struct AutoCommitView: View {
    @EnvironmentObject var githubStatusManager: GitHubStatusManager

    @State private var shouldShowSuccessView: Bool = false

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

                    if githubStatusManager.isLoading {
                        ProgressView()
                    } else {
                        HStack {
                            VStack(alignment: .center, spacing: 10) {
                                if githubStatusManager.commitSummary != "" {
                                    Text("Auto Commit")
                                        .frame(maxWidth: .infinity, alignment: .center)
                                        .font(.custom(FontConstants.titleFont, size: 25))
                                        .foregroundColor(.black)
                                        .padding(.top, 20)

                                    HStack {
                                        Text("\(githubStatusManager.commitSummary)")
                                            .multilineTextAlignment(.leading)
                                            .foregroundColor(.white)

                                        Button {
                                            githubStatusManager.sendMessage()
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
                                    }.padding(.top, -5)
                                        .frame(maxWidth: .infinity)
                                        .padding()
                                        .background(Color.black)
                                        .cornerRadius(30)
                                        .padding(.horizontal, 10)
                                }
                                Spacer()

                                if githubStatusManager.commitSummary == "" {
                                    Button {
                                        self.githubStatusManager.sendMessage()
                                    } label: {
                                        HStack() {
                                            Text("Generate")
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
                                        .padding(.bottom, 250)
                                }
                                else {
                                    Button {
                                        CopyClipboardManager.shared.copyToClipboard(string: githubStatusManager.commitSummary)
                                        self.shouldShowSuccessView = true
                                    } label: {
                                        HStack() {
                                            Text("Copy to clipboard")
                                                .font(.system(size: 15, weight: .bold))
                                        }.frame(width: 150)
                                            .padding(.horizontal, 15)
                                            .padding(.vertical, 10)
                                            .background(Color(hex: ColorConstants.secondColor))
                                            .cornerRadius(15)
                                    }.buttonStyle(.plain)
                                        .padding(.bottom, 250)
                                }
                            }
                        }
                    }

                }
            }

            if shouldShowSuccessView {
                SuccessMessagePopUpView(shouldShow: $shouldShowSuccessView, text: "Copied to clipboard")
            }
        }
    }
}
