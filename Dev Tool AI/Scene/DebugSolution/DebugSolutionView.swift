//
//  DebugSolutionView.swift
//  Dev Tool AI
//
//  Created by Doğancan Mavideniz on 8.07.2023.
//
import SwiftUI
import Alamofire

struct DebugSolutionView: View {
    @StateObject private var viewModel = DebugSolutionViewModel()
    @State private var isTextFieldEmpty = false
    @State private var isLoading = false
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        ZStack {
            VStack {
                Text("Chat Bot")
                    .font(.custom("Futura-CondensedExtraBold", size: 16))
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
                    }
                        .padding(.vertical, 8)
                }

                HStack {
                    if isLoading {
                        ProgressView()
                            .controlSize(.small)
                            .padding(.trailing, 4)
                    }


                    TextField("Mesajınızı yazın", text: $viewModel.currentInput)
                        .frame(height: 25)
                        .textFieldStyle(PlainTextFieldStyle())
                        .padding([.horizontal], 4)
                        .cornerRadius(16)
                        .overlay(RoundedRectangle(cornerRadius: 4).stroke(Color.gray.opacity(0.8)))
                        .onSubmit {
                            if viewModel.currentInput.isEmpty {
                                withAnimation {
                                    isTextFieldEmpty = true
                                }
                            } else {
                                viewModel.sendMessage()
                                withAnimation {
                                    isTextFieldEmpty = false
                                    isLoading = true
                                }

                                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                    isLoading = false
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
                                isLoading = true
                            }

                            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                isLoading = false
                            }
                        }
                    }) {
                        Image(systemName: "paperplane.fill")
                            .cornerRadius(8)
                    }
                }
                    .padding()
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
                    .background(Color.green.opacity(0.2))
                    .cornerRadius(8)
            } else {
                Text(message.content)
                    .padding(12)
                    .foregroundColor(.white)
                    .background(Color.gray.opacity(0.8))
                    .cornerRadius(8)
            }
        }
    }
}

struct DebugSolutionView_Previews: PreviewProvider {
    static var previews: some View {
        DebugSolutionView()
    }
}
