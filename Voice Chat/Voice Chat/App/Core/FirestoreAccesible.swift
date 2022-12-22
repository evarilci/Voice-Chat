//
//  FirestoreAccesible.swift
//  Voice Chat
//
//  Created by Eymen Varilci on 22.12.2022.
//

import Foundation
import FirebaseFirestore
import FirebaseStorage

protocol FireBaseFireStoreAccessible {}

extension FireBaseFireStoreAccessible {
    var db: Firestore {
        Firestore.firestore()
    }
    var storage: Storage {
        Storage.storage()
    }
    
    var StorageMetadata: StorageMetadata {
        FirebaseStorage.StorageMetadata()
    }
}
