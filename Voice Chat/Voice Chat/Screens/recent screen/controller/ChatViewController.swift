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
    let cell = ChatCell()
    var soundRecorder: AVAudioRecorder!
    var timer = Timer()
    //var stopWatch  = Stopwatch()
    var isRecording = false
    var messages : [Message] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view = mainView
        mainView.setTableViewDelegates(delegate: self, datasource: self)
        mainView.micButton.addTarget(self, action: #selector(record), for: .touchUpInside)
        mainView.playButton.addTarget(self, action: #selector(play), for: .touchUpInside)
        mainView.sendButton.addTarget(self, action: #selector(send), for: .touchUpInside)
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Log out", style: .plain, target: self, action: #selector(logOut))
        
        
        loadMessages()
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
    
    func loadMessages() {
        
        db.collection(K.firestore.collectionName)
            .order(by: K.firestore.dateField)
            .addSnapshotListener { snapshot, error in
                self.messages.removeAll()
                if let e = error {
                    self.showAlert(title: "Error", message: e.localizedDescription, cancelButtonTitle: "cancel", handler: nil)
                } else {
                    if let snaphotDocuments = snapshot?.documents {
                        for doc in snaphotDocuments {
                            if let sender = doc.get(K.firestore.senderField) as? String, let record = doc.get(K.firestore.body) as? String {
                                let newMessage = Message(sender: sender, url: record)
                                self.messages.append(newMessage)
                                print(self.messages.count)
                                DispatchQueue.main.async {
                                    self.mainView.tableView.reloadData()
                                }
                            }
                        }
                    }
                }
            }
        }
    
    @objc func send() {
        let referance = storage.reference()
        let mediaFolder = referance.child("media")
        let id = UUID().uuidString // using uuid to give uniq names to audiofiles preventing overwrite
        let mediaRef = mediaFolder.child(id + K.fileName) // creating file referance using uuid + filename
        let path = getFileURL() // getting filepath
        guard let sender = auth.currentUser?.email else {return}
        do {
            let data = try Data(contentsOf: path) // getting data from filepath
            mediaRef.putData(data) { metadata, error in
                if error != nil {
                    self.showAlert(title: "Error", message: error?.localizedDescription, cancelButtonTitle: "cancel", handler: nil)
                } else {
                    mediaRef.downloadURL { url, error in
                        let url = url?.absoluteString
                        self.db.collection(K.firestore.collectionName).addDocument(data: [K.firestore.senderField: sender,
                                                                                          K.firestore.body: url!,
                                                                                          K.firestore.dateField: Date().timeIntervalSince1970]) { error in
                            if let e = error {
                                print(e.localizedDescription)
                            } else {
                                print("message sent succesfuly")
                            }
                        }
                    }
                }
            }
        } catch {
            showAlert(title: "Error", message: error.localizedDescription, cancelButtonTitle: "cancel", handler: nil)
        }
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
    
    @objc func logOut() {
        showAlert(title: "Log Out", message: "You are about to log out", cancelButtonTitle: "Cancel") { _ in
            do {
                try self.auth.signOut()
                
                self.navigationController?.pushViewController(LoginViewController(), animated: true)
                
                print("sign out success")
            } catch  {
                print("sign out failed")
            }
        }
    }
    func playOnMessage(row: Int) {
        let url = URL(string: messages[row].url)!
        let downloadTask = URLSession.shared.downloadTask(with: url) { url, response, error in
            if error != nil {
                print("error in url session")
            } else {
                guard let path = url else {return}
                do {
                    let documentPath = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
                    let savedPath = documentPath.appendingPathComponent(path.lastPathComponent)
                    try FileManager.default.moveItem(at: path, to: savedPath)
                                           let session = AVAudioSession.sharedInstance()
                                           try session.setCategory(AVAudioSession.Category.playback)
                    
                                           let soundData = try Data(contentsOf: savedPath)
                                           self.soundPlayer = try AVAudioPlayer(data: soundData)
                                           self.soundPlayer.prepareToPlay()
                                           self.soundPlayer.volume = 1
                                            self.soundPlayer.play()
                                           self.soundPlayer.delegate = self
                    
                } catch {
                    self.showAlert(title: "Error", message: error.localizedDescription, cancelButtonTitle: "Cancel", handler: nil)
                }
            }
        }
        downloadTask.resume()
    }
}
extension ChatViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = messages[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: K.cellName, for: indexPath) as! ChatCell
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        cell.username = message.sender
        
        cell.playButton.tag = indexPath.row
        cell.action = {
           
            self.playOnMessage(row: indexPath.row)
        }
        if message.sender == auth.currentUser?.email {
            cell.youSender.isHidden = true
            cell.meSender.isHidden = false
            cell.motherView.backgroundColor = .systemIndigo
        } else {
            cell.meSender.isHidden = true
            cell.youSender.isHidden = false
            cell.motherView.backgroundColor = .systemGray5
        }
        return cell
    }
}

extension ChatViewController: AVAudioRecorderDelegate, AVAudioPlayerDelegate {
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        
    }
}
