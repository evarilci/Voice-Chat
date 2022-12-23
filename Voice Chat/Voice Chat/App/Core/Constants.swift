//
//  Constants.swift
//  Voice Chat
//
//  Created by Eymen Varilci on 22.12.2022.
//

import Foundation


struct K {
    static let fileName = "recordedVoice.wav"
    static let cellName = "recentCell"
    
    struct firestore {
        static let collectionName = "messages"
        static let senderField = "sender"
        static let dateField = "date"
        static let body = "body"
    }
}


struct Message {
    let sender : String
    let url : String
    //let date : String
}
