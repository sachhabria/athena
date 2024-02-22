//
//  RecordViewModel.swift
//  Athena
//
//  Created by Sachin Chhabria on 2/11/24.
//

import Foundation
import SwiftUI
import AVFoundation
import FirebaseStorage

class RecordViewModel: NSObject, ObservableObject, AVAudioRecorderDelegate, AVAudioPlayerDelegate {
    var audioRecorder: AVAudioRecorder?
    var audioPlayer: AVAudioPlayer?
    var recordingTimer: Timer?
    var recordingID: UUID?
    
    @Published var isRecording = false
    @Published var recordingDuration = 0
    
    func startRecording() {
        recordingID = UUID()
        let url = getDocumentsDirectory().appendingPathComponent("\(recordingID!.uuidString).m4a")

        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.medium.rawValue
        ]
        
        do {
            audioRecorder = try AVAudioRecorder(url: url, settings: settings)
            audioRecorder?.delegate = self
            audioRecorder?.record()
            isRecording = true
            startTimer()
        } catch {
            print("ERROR: Could not start recording")
        }
    }
    
    func stopRecording(email: String) {
        guard let recordingID = recordingID else { return }
        audioRecorder?.stop()
        isRecording = false
        stopTimer()
        recordingDuration = 0
        let url = getDocumentsDirectory().appendingPathComponent("\(recordingID.uuidString).m4a")
        if let data = try? Data(contentsOf: url) {
            saveRecording(data: data, recordingID: recordingID, email: email)
        }
    }
    
    private func startTimer() {
        recordingTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            self?.recordingDuration += 1
        }
    }
    
    private func stopTimer() {
        recordingTimer?.invalidate()
        recordingTimer = nil
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    func saveRecording(data: Data, recordingID: UUID, email: String) {
        let storageRef = Storage.storage().reference()
        let recordingRef = storageRef.child("\(email)\\\\\\\\\\\(recordingID).m4a")
        let metadata = StorageMetadata()
        metadata.contentType = "audio/m4a"
        
        let uploadTask = recordingRef.putData(data, metadata: metadata) { (metadata, error) in
            guard let metadata = metadata else {
                print("Error uploading recording: \(String(describing: error))")
                return
            }
            print(metadata)
        }
    }
}
