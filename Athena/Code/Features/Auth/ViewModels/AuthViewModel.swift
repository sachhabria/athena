//
//  AuthViewModel.swift
//  Athena
//
//  Created by Sachin Chhabria on 2/11/24.
//

import Foundation
import Combine
import FirebaseAuth
import FirebaseFirestore

class AuthViewModel: ObservableObject {
    
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var fullName: String = ""
    @Published var user: User?
    
    @Published var loginSheetIsPresented: Bool = false
    @Published var isFullNameValid: Bool = false
    @Published var isEmailValid: Bool = false
    @Published var isPasswordValid: Bool = false
    @Published var fullNameValidations: [Validation] = []
    @Published var emailValidations: [Validation] = []
    @Published var passwordValidations: [Validation] = []
    @Published var showValidations: Bool = false
    
    private var cancellableSet: Set<AnyCancellable> = []
    
    init() {
        setupAuthStateListener()
        setupValidationPublishers()
    }
    
    private func setupValidationPublishers() {
        Publishers.CombineLatest3(
            $fullName.removeDuplicates(),
            $email.removeDuplicates(),
            $password.removeDuplicates()
        )
        .map { fullName, email, password in
            return (
                self.validateFullName(fullName),
                self.validateEmail(email),
                self.validatePassword(password)
            )
        }
        .sink { fullNameValidations, emailValidations, passwordValidations in
            self.isFullNameValid = fullNameValidations.allSatisfy { $0.state == ValidationState.success }
            self.isEmailValid = emailValidations.allSatisfy { $0.state == ValidationState.success }
            self.isPasswordValid = passwordValidations.allSatisfy { $0.state == ValidationState.success }
            self.fullNameValidations = fullNameValidations
            self.emailValidations = emailValidations
            self.passwordValidations = passwordValidations
        }
        .store(in: &cancellableSet)
    }
    
    private func setupAuthStateListener() {
        Auth.auth().addStateDidChangeListener { _, user in
            if user != nil {
                Task {
                    try await self.fetchUser()
                }
            } else {
                self.user = nil
            }
        }
    }
    
    private func validateFullName(_ fullName: String) -> [Validation] {
        var validations: [Validation] = []
        if fullName.isEmpty {
            validations.append(Validation(string: fullName, id: 0, field: .fullName, validationType: .isNotEmpty))
        }
        return validations
    }

    private func validateEmail(_ email: String) -> [Validation] {
        var validations: [Validation] = []
        if email.isEmpty {
            validations.append(Validation(string: email, id: 0, field: .email, validationType: .isNotEmpty))
        } else {
            validations.append(Validation(string: email, id: 1, field: .email, validationType: .isEmailValid))
        }
        return validations
    }

    private func validatePassword(_ password: String) -> [Validation] {
        var validations: [Validation] = []
        if password.isEmpty {
            validations.append(Validation(string: password, id: 0, field: .password, validationType: .isNotEmpty))
        } else {
            validations.append(Validation(string: password, id: 1, field: .password, validationType: .minCharacters(min: 8)))
            validations.append(Validation(string: password, id: 2, field: .password, validationType: .hasSymbols))
            validations.append(Validation(string: password, id: 3, field: .password, validationType: .hasUppercasedLetters))
        }
        return validations
    }
}

extension AuthViewModel {
    
    func userExists() async throws -> Bool {
        do {
            let querySnapshot = try await Firestore.firestore()
                .collection("users").whereField("email", isEqualTo: email).getDocuments()
            return !querySnapshot.documents.isEmpty
        } catch {
            print("DEBUG: Error checking user existence: \(error.localizedDescription)")
            throw error
        }
    }
    
    func fetchUser() async throws {
        do {
            if let uid = Auth.auth().currentUser?.uid {
                let userDocument = try await Firestore.firestore().collection("users").document(uid).getDocument()
                self.user = try userDocument.data(as: User.self)
            } else {
                self.user = nil
            }
        } catch {
            print("DEBUG: Error fetching user: \(error.localizedDescription)")
            throw error
        }
    }

    func createUser() async throws {
        do {
            let authResult = try await Auth.auth().createUser(withEmail: email, password: password)
            let user = User(id: authResult.user.uid, fullName: fullName, email: email)
            let encodedUser = try Firestore.Encoder().encode(user)
            try await Firestore.firestore().collection("users").document(user.id).setData(encodedUser)
            try await fetchUser()
        } catch {
            print("DEBUG: Failed to create user with error \(error.localizedDescription)")
            throw error
        }
    }
    
    func signInWithEmail() async throws {
        do {
            try await Auth.auth().signIn(withEmail: email, password: password)
        } catch {
            print("DEBUG: Failed to log in with error \(error.localizedDescription)")
            throw error
        }
    }
    
    func signOut() throws {
        do {
            try Auth.auth().signOut()
        } catch {
            print("DEBUG: Failed to sign out with error \(error.localizedDescription)")
            throw error
        }
    }
    
    func deleteAccount() async throws {
        do {
            if let uid = Auth.auth().currentUser?.uid {
                try await Firestore.firestore().collection("users").document(uid).delete()
            }
            try await Auth.auth().currentUser?.delete()
        } catch {
            print("DEBUG: Failed to delete user with error \(error.localizedDescription)")
            throw error
        }
    }
}
