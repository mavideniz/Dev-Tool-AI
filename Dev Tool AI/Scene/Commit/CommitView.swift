//
//  CommitView.swift
//  Dev Tool AI
//
//  Created by Doğancan Mavideniz on 8.07.2023.
//

import SwiftUI
import Alamofire


struct CommitView: View {
    @State private var selectedIndex = 0
    @State private var isToggleOn = false

    var body: some View {
        ZStack {
            VStack {
                if isToggleOn {
                    AutoCommitView()
                } else {
                    ManuelCommitView()
                }
            }
            VStack {
                Toggle(isOn: $isToggleOn) {
                }
                    .toggleStyle(SymbolToggleStyle(systemImage: "hand.raised.fill", activeColor: .black))
                    .padding()
                Spacer()
            }
        }
    }
}

struct SymbolToggleStyle: ToggleStyle {

    var systemImage: String = "checkmark"
    var activeColor: Color = .green

    func makeBody(configuration: Configuration) -> some View {
        HStack {
            configuration.label

            Spacer()

            RoundedRectangle(cornerRadius: 30)
                .fill(configuration.isOn ? activeColor : Color(.gray))
                .overlay {
                Circle()
                    .fill(.white)
                    .padding(3)
                    .overlay {
                    Image(systemName: systemImage)
                        .foregroundColor(configuration.isOn ? activeColor : Color(.gray))
                }
                    .offset(x: configuration.isOn ? 10 : -10)

            }
                .frame(width: 50, height: 32)
                .onTapGesture {
                withAnimation(.spring()) {
                    configuration.isOn.toggle()
                }
            }
        }
    }
}
