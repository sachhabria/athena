//
//  StringExtensions.swift
//  Athena
//
//  Created by Sachin Chhabria on 2/11/24.
//

import Foundation

extension String {
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }
    func localized(arguments: CVarArg...) -> String {
        return String(format: self.localized, arguments: arguments)
    }
}
