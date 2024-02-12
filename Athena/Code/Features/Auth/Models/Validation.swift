//
//  Validation.swift
//  Athena
//
//  Created by Sachin Chhabria on 2/11/24.
//

import Foundation

enum Field: String {
    case fullName = "Full name"
    case email = "Email"
    case password = "Password"
}

enum ValidationState {
    case success
    case failure
}

enum ValidationType {
    case isEmailValid
    case isNotEmpty
    case minCharacters(min: Int)
    case hasSymbols
    case hasUppercasedLetters
    
    func fulfills(string: String) -> Bool {
        switch self {
        case .isEmailValid:
            return string.isValidEmail()
        case .isNotEmpty:
            return !string.isEmpty
        case .minCharacters(min: let min):
            return string.count > min
        case .hasSymbols:
            return string.hasSpecialCharacters()
        case .hasUppercasedLetters:
            return string.hasUppercasedCharacters()
        }
    }
    
    func message(fieldName: String) -> String {
        switch self {
        case .isNotEmpty:
            return "\(fieldName) is required"
        case .isEmailValid:
            return "Please enter a valid email address"
        case .minCharacters(min: let min):
            return "Must be longer than \(min) characters"
        case .hasSymbols:
            return "Must have a symbol"
        case .hasUppercasedLetters:
            return "Must have an uppercase letter"
        }
    }
}

struct Validation: Identifiable {
    var id: Int
    var field: Field
    var validationType: ValidationType
    var state: ValidationState
    
    init(string: String, id: Int, field: Field, validationType: ValidationType) {
        self.id = id
        self.field = field
        self.validationType = validationType
        self.state = validationType.fulfills(string: string) ? .success : .failure
    }
}

extension String {
    
    func isValidEmail() -> Bool {
        return stringFulfillsRegex(regex: "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}")
    }

    func hasUppercasedCharacters() -> Bool {
        return stringFulfillsRegex(regex: ".*[A-Z]+.*")
    }

    func hasSpecialCharacters() -> Bool {
        return stringFulfillsRegex(regex: ".*[^A-Za-z0-9].*")
    }
    
    private func stringFulfillsRegex(regex: String) -> Bool {
        let texttest = NSPredicate(format: "SELF MATCHES %@", regex)
        guard texttest.evaluate(with: self) else {
            return false
        }
        return true
    }
}
