//
//  HintView.swift
//  Athena
//
//  Created by Sachin Chhabria on 2/11/24.
//

import SwiftUI

struct HintView: View {
    let text: String
    
    var body: some View {
        Text(text)
            .font(.caption)
            .foregroundStyle(Color(.systemGray))
    }
}
