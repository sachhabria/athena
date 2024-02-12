//
//  LoginButtonView.swift
//  Athena
//
//  Created by Sachin Chhabria on 2/11/24.
//

import SwiftUI

enum LoginButtonType: String {
    case email = "Email"
    case google = "Google"
    case facebook = "Facebook"
    case apple = "Apple"
}

struct LoginButtonView: View {
    let type: LoginButtonType
    let action: () -> Void
    
    var body: some View {
        Button {
            action()
        } label: {
            HStack {
                Image(type.rawValue)
                    .resizable()
                    .frame(width: 20, height: 20)
                
                Text("\("ContinueButton.Title".localized) \("With".localized) \(type.rawValue)")
            }
        }
        .buttonStyle(MainButtonStyle(type: .secondary))
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(.black, lineWidth: 0.3)
        )
    }
}
