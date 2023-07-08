//
//  ChatAppView.swift
//  Dev Tool AI
//
//  Created by Doğancan Mavideniz on 8.07.2023.
//
import SwiftUI
import Alamofire

struct ChatAppView: View {
    @StateObject private var viewModel = ChatAppViewModel()
    @State private var isTextFieldEmpty = false
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        ZStack {
            VStack {
                Text("👨🏻‍💻 Chat Bot")
                    .font(.custom(FontConstants.titleFont, size: 20))
                    .padding(.top)
                Text("Your code buddy")
                    .font(.custom(FontConstants.titleFont, size: 16))
                    .foregroundColor(.white.opacity(0.6))
                ScrollView {
                    ScrollViewReader { scrollViewProxy in
                        LazyVStack(spacing: 8) {
                            ForEach(viewModel.messages.filter({ $0.role != .system }), id: \.id) { message in
                                messageView(message: message)
                                    .id(message.id)
                                    .frame(maxWidth: .infinity, alignment: message.role == .user ? .trailing : .leading)
                            }
                        }
                            .padding(.horizontal)
                            .onChange(of: viewModel.messages) { _ in
                            withAnimation {
                                scrollViewProxy.scrollTo(viewModel.messages.last?.id, anchor: .bottom)
                            }
                        }
                    }.padding(.vertical, 8)
                }

                HStack {
                    if viewModel.isLoading {
                        ProgressView()
                            .controlSize(.small)
                            .padding(.trailing, 4)
                    }

                    TextField("Write your message", text: $viewModel.currentInput)
                        .textFieldStyle(.plain)
                        .padding(10)
                        .background(Color(hex: "#767a82"))
                        .font(.system(size: 16))
                        .frame(height: 40)
                        .cornerRadius(10)
                        .onSubmit {
                        if viewModel.currentInput.isEmpty {
                            withAnimation {
                                isTextFieldEmpty = true
                            }
                        } else {
                            viewModel.sendMessage()
                            withAnimation {
                                isTextFieldEmpty = false
                            }
                        }
                    }

                    Button(action: {
                        if viewModel.currentInput.isEmpty {
                            withAnimation {
                                isTextFieldEmpty = true
                            }
                        } else {
                            viewModel.sendMessage()
                            withAnimation {
                                isTextFieldEmpty = false
                                viewModel.isLoading = true
                            }
                        }
                    }) {
                        Image(systemName: "paperplane.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 20)
                            .padding(10)
                            .background(Color(hex: ColorConstants.secondColor))

                            .cornerRadius(8)
                    }.buttonStyle(PlainButtonStyle())
                }.padding(.bottom, 15)
                    .padding(.horizontal, 15)
            }
                .cornerRadius(16)
                .shadow(color: Color.black.opacity(0.1), radius: 8, x: 0, y: 4)
        }
    }

    func messageView(message: Message) -> some View {
        VStack(alignment: message.role == .user ? .trailing : .leading, spacing: 8) {
            if message.role == .assistant {
                Text(message.content)
                    .padding(12)
                    .foregroundColor(.white)
                    .background(Color(hex: ColorConstants.mainColor))
                    .cornerRadius(8)
                    .font(.custom(FontConstants.messageFont, size: 16))
            } else {
                Text(message.content)
                    .padding(12)
                    .foregroundColor(.white)
                    .background(Color(hex: ColorConstants.secondColor))
                    .cornerRadius(8)
                    .font(.custom(FontConstants.messageFont, size: 16))
            }
        }.font(.system(size: 16))
    } }

struct ChatAppView_Previews: PreviewProvider {
    static var previews: some View {
        ChatAppView()
    }
}
