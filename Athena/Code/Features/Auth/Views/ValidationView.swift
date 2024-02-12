//
//  ValidationView.swift
//  Athena
//
//  Created by Sachin Chhabria on 2/11/24.
//

import SwiftUI

struct ValidationRowView: View {
    let validation: Validation
    let errorColor = Color(red: 178 / 255.0, green: 65 / 255.0, blue: 37 / 255.0)

    var body: some View {
        HStack {
            Image(systemName: validation.state == .success ? "checkmark.circle.fill" : "exclamationmark.circle")
                .resizable()
                .frame(width: 10, height: 10)
            
            Text(validation.validationType.message(fieldName: validation.field.rawValue))
                .font(.caption)
        }
        .fontWeight(.semibold)
        .foregroundColor(validation.state == .success ? Color.gray : errorColor)
    }
}
