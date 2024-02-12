//
//  NavigationButtonStyle.swift
//  Athena
//
//  Created by Sachin Chhabria on 2/11/24.
//

import SwiftUI

struct NavButtonStyle: ButtonStyle {

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundColor(.black)
            .background {
                Circle()
                    .fill(configuration.isPressed ? Color(.systemGray4) : .white)
                    .frame(width: 24, height: 24)
            }
            .animation(.easeOut(duration: 0.2), value: configuration.isPressed)
    }
}
