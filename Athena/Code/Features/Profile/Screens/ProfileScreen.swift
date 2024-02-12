//
//  ProfileScreen.swift
//  Athena
//
//  Created by Sachin Chhabria on 2/11/24.
//

import SwiftUI

struct ProfileScreen: View {
    @EnvironmentObject var viewModel: AuthViewModel
    @State private var showSignOutAlert = false
    
    private func signOut() {
        Task {
            try viewModel.signOut()
        }
    }
    
    private func deleteAccount() {
        Task {
            try await viewModel.deleteAccount()
        }
    }
    
    var body: some View {
        if let user = viewModel.user {
            List {
                Section {
                    HStack {
                        Text(user.initials)
                            .font(.title)
                            .fontWeight(.semibold)
                            .foregroundStyle(.white)
                            .frame(width: 72, height: 72)
                            .background(Color(.systemGray2))
                            .clipShape(.circle)
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text(user.fullName)
                                .font(.subheadline)
                                .fontWeight(.semibold)
                                .padding(.top, 4)
                            
                            Text(user.email)
                                .font(.footnote)
                                .foregroundColor(.gray)
                        }
                    }
                }
                
                Section {
                    HStack {
                        Spacer()
                        Button {
                            showSignOutAlert = true
                        } label: {
                            Text("LogOutButton.Title".localized)
                                .font(.subheadline)
                                .foregroundStyle(Color.red)
                        }
                        .actionSheet(isPresented: $showSignOutAlert) {
                            ActionSheet(
                                title: Text("LogOutButton.Title".localized),
                                message: Text("ProfileScreen.LogOut.Description".localized),
                                buttons: [
                                    .default(Text("LogOutButton.Title".localized).foregroundStyle(.red)) {
                                        signOut()
                                    },
                                    .cancel()
                                ]
                            )
                        }
                        Spacer()
                    }
                }
            }
        } else {
            NavigationStack {
                ScrollView {
                    VStack {
                        VStack(alignment: .leading, spacing: 32) {
                            
                            Text("ProfileScreen.Title".localized)
                                .font(.title)
                                .fontWeight(.bold)
                            
                            Text("ProfileScreen.Description".localized)
                        
                            // login button
                            Button {
                                viewModel.loginSheetIsPresented = true
                            } label: {
                                Text("LoginButton.Title".localized)
                            }
                            .frame(height: 60)
                            .buttonStyle(MainButtonStyle(type: .primary))
                            .sheet(isPresented: $viewModel.loginSheetIsPresented) { EmailScreen() }
                            
                            // signup button
                            HStack {
                                Text("ProfileScreen.DontHaveAnAccountYet".localized)
                                
                                Text("SignupButton.Title".localized)
                                    .fontWeight(.semibold)
                                    .underline()
                                    .onTapGesture {
                                        viewModel.loginSheetIsPresented = true
                                    }
                            }
                            .font(.caption)
                        }
                        
                        Spacer()
                    }
                    .padding()
                }
            }
        }
    }
}

#Preview {
    ProfileScreen().environmentObject(AuthViewModel())
}
