//
//  ContentView.swift
//  Athena
//
//  Created by Sachin Chhabria on 2/11/24.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var viewModel: AuthViewModel
    
    var body: some View {
        RootScreen()
            .environmentObject(AuthViewModel())
    }
}

#Preview {
    ContentView().environmentObject(AuthViewModel())
}
