//
//  SuccessMessagePopUpView.swift
//  Dev Tool AI
//
//  Created by Giray on 8.07.2023.
//

import SwiftUI

struct SuccessMessagePopUpView: View {

    @Binding var shouldShow: Bool

    let text: String

    var body: some View {
        Text("\(text)")
            .font(.system(size: 18))
            .multilineTextAlignment(.center)
            .foregroundColor(.white)
            .padding()
            .padding(.horizontal, 10)
            .background(Color(hex: ColorConstants.thirdColor)?.opacity(0.7))
            .cornerRadius(30)
            .frame(maxHeight: .infinity, alignment: .bottom)
            .padding(.bottom, 10)
            .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                    self.shouldShow = false
                })
        }
    }
}
