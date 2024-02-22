//
//  RecordScreen.swift
//  Athena
//
//  Created by Sachin Chhabria on 2/11/24.
//

import SwiftUI

struct RecordScreen: View {
    
    @EnvironmentObject var viewModel: AuthViewModel
    @State private var loginSheetIsPresented: Bool = false
    @StateObject private var audioRecorderPlayer = RecordViewModel()
    @State private var className: String = ""
    
    var body: some View {
        
        if viewModel.user != nil {
            VStack {
                Spacer()
                
                Button(action: {
                    if audioRecorderPlayer.isRecording {
                        audioRecorderPlayer.stopRecording(email: viewModel.user?.email ?? "")
                    } else {
                        audioRecorderPlayer.startRecording()
                    }
                }) {
                    ZStack {
                        // Outer Circle
                        Circle()
                            .strokeBorder(Color(.systemGray), lineWidth: 3)
                            .frame(width: 64, height: 64)
                        
                        // Shape that morphs between Circle and Square
                        RoundedRectangle(cornerRadius: audioRecorderPlayer.isRecording ? 4 : 26)
                            .fill(Color.red)
                            // Adjust the frame size if needed when recording
                            .frame(width: audioRecorderPlayer.isRecording ? 26 : 52, height: audioRecorderPlayer.isRecording ? 26 : 52)
                            .animation(.easeInOut(duration: 0.2), value: audioRecorderPlayer.isRecording)
                    }
                }
                .animation(.easeInOut(duration: 0.2), value: audioRecorderPlayer.isRecording)
                
                if audioRecorderPlayer.isRecording {
                    Text("\(formatDuration(audioRecorderPlayer.recordingDuration))")
                       .font(.largeTitle)
                       .padding()
                }
            }
        } else {
            NavigationStack {
                VStack(alignment: .leading, spacing: 32) {
                    
                    Text("RecordScreen.Title".localized)
                        .font(.title)
                        .fontWeight(.bold)
                    
                    Text("RecordScreen.Description".localized)
                    
                    Button {
                        loginSheetIsPresented.toggle()
                    } label: {
                        Text("LoginButton.Title".localized)
                    }
                    .frame(height: 60)
                    .buttonStyle(MainButtonStyle(type: .primary))
                    .sheet(isPresented: $loginSheetIsPresented) {
                        EmailScreen()
                    }
                    
                    Spacer()
                }
                .padding()
            }
        }
    }
    
    private func formatDuration(_ seconds: Int) -> String {
        let minutes = seconds / 60
        let remainingSeconds = seconds % 60
        return String(format: "%02d:%02d", minutes, remainingSeconds)
    }
}

#Preview {
    RecordScreen().environmentObject(AuthViewModel())
}
