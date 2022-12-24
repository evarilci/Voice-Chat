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
    
    var soundPlayer : AVAudioPlayer!
    var soundRecorder: AVAudioRecorder!
    var isRecording = false
    var messages : [Message] = []
    var audioEngine = AVAudioEngine()
    let pitch = AVAudioUnitTimePitch()
    let speedControl = AVAudioUnitVarispeed()
    var audioMixer: AVAudioMixerNode!
    
    // var recordedAudioURL: URL!
    var audioFile: AVAudioFile!
    
    var audioPlayerNode: AVAudioPlayerNode!
    //var stopTimer: Timer!
    
    var filteredOutputURL: NSURL!
    var newAudio: AVAudioFile!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view = mainView
        mainView.setTableViewDelegates(delegate: self, datasource: self)
        mainView.micButton.addTarget(self, action: #selector(record), for: .touchUpInside)
        mainView.playButton.addTarget(self, action: #selector(play), for: .touchUpInside)
        mainView.sendButton.addTarget(self, action: #selector(send), for: .touchUpInside)
        mainView.lowPitchPlayButton.addTarget(self, action: #selector(lowPitchPlay), for: .touchUpInside)
        mainView.highPitchPlayButton.addTarget(self, action: #selector(highPitchPlay), for: .touchUpInside)
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Log out", style: .plain, target: self, action: #selector(logOut))
        loadMessages()
        setupAudio()
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
        playSound()
    }
    
    @objc func lowPitchPlay() {
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(true)
        playSound(pitch: -600)
    }
    
    @objc func highPitchPlay() {
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(true)
        playSound(pitch: 600)
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
                                    let indexPath = IndexPath(row: self.messages.count - 1, section: 0)
                                    self.mainView.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
                                    
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
        let path = newAudio.url // getting filepath
        //let path = audioFile
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
            mainView.micButton.setImage(UIImage(named: "Stop"), for: .normal)
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
            mainView.micButton.setImage(UIImage(named: "Record"), for: .normal)
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
        cell.motherView.cornerRadius = cell.motherView.frame.height / 5
        return cell
    }
}

extension ChatViewController: AVAudioRecorderDelegate, AVAudioPlayerDelegate {
    
    // MARK: Audio Functions
    
    func setupAudio() {
        // initialize (recording) audio file
        do {
            audioFile = try AVAudioFile(forReading: getFileURL() as URL)
        } catch {
            print("error: \(error)")
        }
    }
    
    
    func playSound(rate: Float? = nil, pitch: Float? = nil, echo: Bool = false, reverb: Bool = false) {
        
        // initialize audio engine components
        audioEngine = AVAudioEngine()
        
        // node for playing audio
        audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attach(audioPlayerNode)
        
        audioMixer = AVAudioMixerNode()
        audioEngine.attach(audioMixer)
        
        // node for adjusting rate/pitch
        let changeRatePitchNode = AVAudioUnitTimePitch()
        if let pitch = pitch {
            changeRatePitchNode.pitch = pitch
        }
        if let rate = rate {
            changeRatePitchNode.rate = rate
        }
        audioEngine.attach(changeRatePitchNode)
        
        // node for echo
        let echoNode = AVAudioUnitDistortion()
        echoNode.loadFactoryPreset(.multiEcho1)
        audioEngine.attach(echoNode)
        
        // node for reverb
        let reverbNode = AVAudioUnitReverb()
        reverbNode.loadFactoryPreset(.cathedral)
        reverbNode.wetDryMix = 50
        audioEngine.attach(reverbNode)
        
        
        // connect nodes
        if echo == true && reverb == true {
            connectAudioNodes(audioPlayerNode, changeRatePitchNode, echoNode, reverbNode, audioMixer, audioEngine.outputNode)
        } else if echo == true {
            connectAudioNodes(audioPlayerNode, changeRatePitchNode, echoNode, audioMixer, audioEngine.outputNode)
        } else if reverb == true {
            connectAudioNodes(audioPlayerNode, changeRatePitchNode, reverbNode, audioMixer, audioEngine.outputNode)
        } else {
            connectAudioNodes(audioPlayerNode, changeRatePitchNode, audioMixer, audioEngine.outputNode)
        }
        
        
        // schedule to play and start the engine!
        audioPlayerNode.stop()
        audioPlayerNode.scheduleFile(audioFile, at: nil) {
            
        }
        
        do {
            try audioEngine.start()
            
        } catch {
            self.showAlert(title: "Error", message: error.localizedDescription, cancelButtonTitle: "cancel", handler: nil)
            return
        }
        
        let audioAsset = AVURLAsset.init(url: getFileURL(), options: nil)
        let durationInSeconds = CMTimeGetSeconds(audioAsset.duration)
        
        
        let dirPaths: AnyObject = NSSearchPathForDirectoriesInDomains( FileManager.SearchPathDirectory.documentDirectory,  FileManager.SearchPathDomainMask.userDomainMask, true)[0] as AnyObject
        let tmpFileUrl: NSURL = NSURL.fileURL(withPath: dirPaths.appendingPathComponent("effectedSound.caf")) as NSURL
        
        filteredOutputURL = tmpFileUrl
        
        do{
            print(dirPaths)
            self.newAudio = try AVAudioFile(forWriting: tmpFileUrl as URL, settings: [:])
            
            audioMixer.installTap(onBus: 0, bufferSize: (AVAudioFrameCount(durationInSeconds)), format: self.audioPlayerNode.outputFormat(forBus: 0)){ [self]
                (buffer: AVAudioPCMBuffer!, time: AVAudioTime!)  in
                
                if (self.newAudio!.length) < (self.audioFile.length){
                    
                    do{
                        //print(buffer)
                        try self.newAudio!.write(from: buffer)
                    }catch _{
                        print("Problem Writing Buffer")
                    }
                }else{
                    audioPlayerNode.removeTap(onBus: 0)
                }
                
            }
        }catch _{
            print("Problem")
        }
        
        // play the recording!
        audioPlayerNode.play()
        
    }
    
    func connectAudioNodes(_ nodes: AVAudioNode...) {
        for x in 0..<nodes.count-1 {
            audioEngine.connect(nodes[x], to: nodes[x+1], format: audioFile.processingFormat)
        }
    }
}
