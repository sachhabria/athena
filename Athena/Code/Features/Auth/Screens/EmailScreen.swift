//
//  EmailScreen.swift
//  Athena
//
//  Created by Sachin Chhabria on 2/11/24.
//

import SwiftUI

struct EmailScreen: View {
    @EnvironmentObject var viewModel: AuthViewModel
    @State private var navigateToPasswordScreen = false
    @State private var navigateToRegistrationScreen = false
    
    private func navigate() {
        Task {
            if try await viewModel.userExists() {
                navigateToPasswordScreen = true
            } else {
                navigateToRegistrationScreen = true
            }
        }
    }

    init() {
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = UIColor.systemBackground

        let dividerColor = UIColor.darkGray
        let dividerSize = CGSize(width: UIScreen.main.bounds.width, height: 1 / UIScreen.main.scale)
        UIGraphicsBeginImageContext(dividerSize)
        let context = UIGraphicsGetCurrentContext()!
        context.setFillColor(dividerColor.cgColor)
        context.fill(CGRect(origin: .zero, size: dividerSize))
        let dividerImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        appearance.shadowImage = dividerImage
        appearance.shadowColor = nil

        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().compactAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 30) {
                    
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
                    
                    Button(action: {
                        if viewModel.isEmailValid {
                            navigate()
                            viewModel.showValidations = false
                        } else {
                            viewModel.showValidations = true
                        }
                    }, label: {
                        Text("ContinueButton.Title".localized)
                    })
                    .buttonStyle(MainButtonStyle(type: .primary))
                    .navigationDestination(isPresented: $navigateToPasswordScreen) { PasswordScreen() }
                    .navigationDestination(isPresented: $navigateToRegistrationScreen) { RegistrationScreen() }
                }
                .padding()
            }
            .navigationBarTitle("EmailScreen.Title".localized, displayMode: .inline)
            .navigationBarItems(leading: CloseButtonView().padding())
        }
    }
}

#Preview {
    EmailScreen().environmentObject(AuthViewModel())
}
