//
//  RootScreen.swift
//  Athena
//
//  Created by Sachin Chhabria on 2/11/24.
//

import SwiftUI

struct RootScreen: View {
    @EnvironmentObject var viewModel: AuthViewModel

    var body: some View {
        TabView {
            RecordScreen()
                .tabItem { Label("Record", systemImage: "plus") }
            
            ProfileScreen()
                .environmentObject(viewModel)
                .tabItem { Label("Profile", systemImage: "person.crop.circle") }
        }
    }
}

#Preview {
    RootScreen().environmentObject(AuthViewModel())
}
