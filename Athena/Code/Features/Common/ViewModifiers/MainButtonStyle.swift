//
//  MainButtonStyle.swift
//  Athena
//
//  Created by Sachin Chhabria on 2/11/24.
//

import SwiftUI

enum ButtonType {
    case primary
    case secondary
}

struct MainButtonStyle: ButtonStyle {
    let type: ButtonType
    
    private var textColor: Color {
        switch type {
        case .primary:
            return Color.white
        case .secondary:
            return Color.black
        }
    }
    
    private var backgroundColor: Color {
        switch type {
        case .primary:
            return Color.indigo
        case .secondary:
            return Color.white
        }
    }
    
    private var height: CGFloat {
        switch type {
        case .primary:
            return 60
        case .secondary:
            return 48
        }
    }

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundColor(textColor)
            .font(.body)
            .fontWeight(.semibold)
            .frame(maxWidth: .infinity, minHeight: height, maxHeight: height)
            .background(type == .secondary && configuration.isPressed ? Color(.systemGray4) : backgroundColor)
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .scaleEffect(type == .primary && configuration.isPressed ? 0.95 : 1.0)
            .animation(.easeOut(duration: 0.2), value: configuration.isPressed)
    }
}
