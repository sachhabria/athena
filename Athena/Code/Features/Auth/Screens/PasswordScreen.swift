//
//  PasswordScreen.swift
//  Athena
//
//  Created by Sachin Chhabria on 2/11/24.
//

import SwiftUI

struct PasswordScreen: View {
    @EnvironmentObject var viewModel: AuthViewModel
    
    private func signInWithEmail() {
        Task {
            try await viewModel.signInWithEmail()
        }
        if viewModel.user != nil {
            viewModel.loginSheetIsPresented = false
        }
    }
    
    var body: some View {
        
        VStack(alignment: .center, spacing: 30) {
            
            // Logo and welcome text
            VStack {
                Image(systemName: "pencil.and.list.clipboard")
                    .resizable()
                    .frame(width: 60, height: 60)
                    .foregroundColor(.indigo)
                
                Text("PasswordScreen.WelcomeMessage")
                    .font(.title)
            }
            
            // Password field
            InputView(type: .password, text: $viewModel.password)
            
            // Login button
            Button(action: signInWithEmail) {
                Text("LoginButton.Title".localized)
            }
            .buttonStyle(MainButtonStyle(type: .primary))
            
            Spacer()
        }
        .padding()
        .navigationBarBackButtonHidden()
        .navigationBarTitle("PasswordScreen.Title".localized, displayMode: .inline)
        .navigationBarItems(leading:
            BackButtonView()
            .padding()
        )
    }
}

#Preview {
    PasswordScreen().environmentObject(AuthViewModel())
}
