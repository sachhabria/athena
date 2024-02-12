//
//  RegistrationScreen.swift
//  Athena
//
//  Created by Sachin Chhabria on 2/11/24.
//

import SwiftUI

struct RegistrationScreen: View {
    @EnvironmentObject var viewModel: AuthViewModel
    
    private func createUser() {
        Task {
            try await viewModel.createUser()
        }
        if viewModel.user != nil {
            viewModel.loginSheetIsPresented = false
        }
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 30) {
                
                // form fields
                VStack(alignment: .leading, spacing: 24) {
                    
                    // Full Name field
                    VStack(alignment: .leading, spacing: 12) {
                        InputView(type: .name, text: $viewModel.fullName)
                        if !viewModel.isFullNameValid && viewModel.showValidations {
                            ForEach(viewModel.fullNameValidations) { validation in
                                ValidationRowView(validation: validation)
                            }
                        } else {
                            HintView(text: "RegistrationScreen.FullNameField.Hint".localized)
                        }
                    }
                    
                    // Email field
                    VStack(alignment: .leading, spacing: 10) {
                        InputView(type: .email, text: $viewModel.email)
                        if !viewModel.isEmailValid && viewModel.showValidations {
                            ForEach(viewModel.emailValidations) { validation in
                                ValidationRowView(validation: validation)
                            }
                        } else {
                            HintView(text: "EmailScreen.EmailField.Hint".localized)
                        }
                    }

                    VStack(alignment: .leading, spacing: 10) {
                        InputView(type: .password, text: $viewModel.password)
                        
                        if !viewModel.isPasswordValid && viewModel.showValidations {
                            ForEach(viewModel.passwordValidations) { validation in
                                ValidationRowView(validation: validation)
                            }
                        } else {
                            HintView(text: "RegistrationScreen.PasswordField.Hint".localized)
                        }
                    }
                }

                // Create account button
                Button(action: {
                    if viewModel.isFullNameValid && viewModel.isEmailValid && viewModel.isPasswordValid {
                        createUser()
                    } else {
                        viewModel.showValidations = true
                    }
                }, label: {
                    Text("ContinueButton.Title".localized)
                })
                .buttonStyle(MainButtonStyle(type: .primary))
                
                Spacer()
            }
            .padding()
            .navigationBarBackButtonHidden()
            .navigationBarTitle("RegistrationScreen.Title".localized, displayMode: .inline)
            .navigationBarItems(leading:
                BackButtonView()
                .padding()
            )
        }
    }
}

#Preview {
    RegistrationScreen().environmentObject(AuthViewModel())
}

