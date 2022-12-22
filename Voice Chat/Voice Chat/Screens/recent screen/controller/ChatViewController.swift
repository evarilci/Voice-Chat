//
//  ChatViewController.swift
//  Voice Chat
//
//  Created by Eymen Varilci on 21.12.2022.
//

import UIKit
import AVFoundation




final class ChatViewController: UIViewController, AlertPresentable, FireBaseFireStoreAccessible {
    
    let mainView = ChatTableView()
    let pitch = AVAudioUnitTimePitch()
    var soundPlayer : AVAudioPlayer!
    
        var soundRecorder: AVAudioRecorder!
        var timer = Timer()
        var stopWatch = Stopwatch()
        var isRecording = false
//        var fileName: String = "recordedVoice.wav"
    
    override func viewDidLoad() {
        super.viewDidLoad()
            
        view = mainView
        mainView.setTableViewDelegates(delegate: self, datasource: self)
        mainView.micButton.addTarget(self, action: #selector(record), for: .touchUpInside)
        mainView.playButton.addTarget(self, action: #selector(play), for: .touchUpInside)
        mainView.sendButton.addTarget(self, action: #selector(send), for: .touchUpInside)
    }
    func getDocumentsDirectory() -> URL {
           let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
           return paths[0]
       }
    func getFileURL() -> URL {
        let path = getDocumentsDirectory()
        let filePath = path.appendingPathComponent(K.fileName)
        
        return filePath
    }
    
    func setupPlayer() {
        let audioFilename = getDocumentsDirectory().appendingPathComponent(K.fileName)
           do {
               soundPlayer = try AVAudioPlayer(contentsOf: audioFilename)
               soundPlayer.delegate = self
               soundPlayer.prepareToPlay()
               soundPlayer.volume = 1.0
           } catch {
               showAlert(title: "Error", message: error.localizedDescription, cancelButtonTitle: "Cancel", handler: nil)
           }
       }
    
    @objc func play() {
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(true)
             setupPlayer()
             soundPlayer.play()
            
    }
    
    @objc func send() {
        let referance = storage.reference()
        let mediaFolder = referance.child("media")
        let id = UUID().uuidString
        let mediaRef = mediaFolder.child(id + K.fileName)
       
        
        
        let path = getFileURL()
        
        do {
            let data = try Data(contentsOf: path)
            mediaRef.putData(data) { metadata, error in
                if error != nil {
                    self.showAlert(title: "Error", message: error?.localizedDescription, cancelButtonTitle: "cancel", handler: nil)
                } else {
                    mediaRef.downloadURL { url, error in
                        let url = url?.absoluteString
                        print("UPLOADED AND HERE IS YOUR URL MY MASTER: \(url)")
                    }
                }
            }
            
            print("record has come")
//            let mediaref = mediaFolder.child(K.fileName)
//            let metadata = StorageMetadata
//            metadata.contentType = "audio/wav"
//            if let uploadData = AVFileType(data) {
//
//            }

        } catch {
            print("error cant get audio file")
        }
       
        
//        if let data = soundPlayer.data {
//            let mediaRef = mediaFolder.child(K.fileName)
//            mediaRef.putData(data) { metadata, error in
//                if error != nil {
//                    self.showAlert(title: "Error", message: error?.localizedDescription, cancelButtonTitle: "Cancel", handler: nil)
//                } else {
//                    mediaRef.downloadURL { url, error in
//                        let url = url?.absoluteString
//                        print(url)
//
//                    }
//                }
//            }
//        }
        
    }
    
    @objc func record() {
        if !isRecording {
            isRecording = true
            
            let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true)[0] as String
                let pathArray = [dirPath, K.fileName]
                    //create file path
                    let filePath = URL(string: pathArray.joined(separator: "/"))
                    
                    //start and config AV session
                    let session = AVAudioSession.sharedInstance()
                    try! session.setCategory(AVAudioSession.Category.playAndRecord, options:AVAudioSession.CategoryOptions.defaultToSpeaker)
                    
                    //start recorder
            
            do {
                try soundRecorder = AVAudioRecorder(url: filePath!, settings: [:])
                soundRecorder.delegate = self
                soundRecorder.isMeteringEnabled = true
                soundRecorder.prepareToRecord() //Creates an audio file and prepares the system for recording.
                soundRecorder.record()
            } catch {
                showAlert(title: "Error", message: error.localizedDescription, cancelButtonTitle: "Cancel", handler: nil)
            }
        } else {
            isRecording = false
            soundRecorder.stop()
                   
        }
       
    }
    
}


extension ChatViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.cellName, for: indexPath) as! ChatCell
        cell.username = "eymen varilcialsdjlakjsdlakjdkljasldkjaskldjakljdlkadjlakjdlkajdlkajdlkajdklasjdlkasjdalkdjlakjdlakjdkladjkasjdal"
        return cell
    }
    
    
}


extension ChatViewController: AVAudioRecorderDelegate, AVAudioPlayerDelegate {
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        
    }
    
}
