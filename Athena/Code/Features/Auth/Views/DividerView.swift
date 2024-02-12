//
//  DividerView.swift
//  Athena
//
//  Created by Sachin Chhabria on 2/11/24.
//

import SwiftUI

struct DividerView: View {
    var body: some View {
        HStack {
            VStack { Divider() }
            Text("or")
                .font(.caption)
                .foregroundColor(Color(.darkGray))
            VStack { Divider() }
        }
    }
}

#Preview {
    DividerView()
}
