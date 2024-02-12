//
//  CloseButtonView.swift
//  Athena
//
//  Created by Sachin Chhabria on 2/11/24.
//

import SwiftUI

struct CloseButtonView: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        Button {
            dismiss()
        } label: {
            Image(systemName: "xmark")
                .resizable()
                .frame(width: 10, height: 10)
        }
        .buttonStyle(NavButtonStyle())
    }
}

#Preview {
    CloseButtonView()
}
