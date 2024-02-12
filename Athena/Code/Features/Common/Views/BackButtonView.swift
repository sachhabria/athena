//
//  BackButtonView.swift
//  Athena
//
//  Created by Sachin Chhabria on 2/11/24.
//

import SwiftUI

struct BackButtonView: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        Button {
            dismiss()
        } label: {
            Image("arrow-left")
                .resizable()
                .frame(width: 12, height: 12)
        }
        .buttonStyle(NavButtonStyle())
    }
}

#Preview {
    BackButtonView()
}
