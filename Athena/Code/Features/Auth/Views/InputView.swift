//
//  InputView.swift
//  Athena
//
//  Created by Sachin Chhabria on 2/11/24.
//

import SwiftUI

enum InputType {
    case name
    case email
    case password
}

struct InputView: View {
    let type: InputType
    @Binding var text: String
    @FocusState private var isFocused: Bool
    @State private var showPassword: Bool = false  // Toggle password visibility
    
    private var placeholder: String {
        switch type {
        case .name:
            return "RegistrationScreen.FullNameField.Title".localized
        case .email:
            return "EmailScreen.EmailField.Title".localized
        case .password:
            return "PasswordScreen.PasswordField.Title".localized
        }
    }
    
    var body: some View {
        
        ZStack(alignment: .leading) {
            
            Group {
                    if type == .password && !showPassword {
                        SecureField("", text: $text)
                    } else {
                        TextField("", text: $text)
                    }
                }
            .focused($isFocused)
            .offset(y: isFocused || text != "" ? 10 : 0)
            .font(.subheadline)
            .autocorrectionDisabled()
            .textInputAutocapitalization(type == .name ? .words : .never)
            
            Text(placeholder)
                .foregroundColor(Color(.darkGray))
                .font(isFocused || text != "" ? .footnote : .subheadline)
                .offset(y: isFocused || text != "" ? -10 : 0)
                .animation(.easeInOut(duration: 0.2), value: isFocused)
            
            // Show/Hide button for password
            if type == .password {
                HStack {
                    Spacer()
                    Button(action: {
                        self.showPassword.toggle()
                    }) {
                        Text(showPassword ? "Hide" : "Show")
                            .font(.caption)
                            .underline()
                            .foregroundStyle(.black)
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, minHeight: 60, maxHeight: 60)
        .padding(.horizontal, 16)
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(lineWidth: isFocused ? 2 : 0.5))
        .animation(.default, value: isFocused)
        .onTapGesture {
            self.isFocused = true
        }
    }
}
