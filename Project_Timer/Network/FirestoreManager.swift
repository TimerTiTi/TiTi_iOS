//
//  FirestoreManager.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2022/06/06.
//  Copyright © 2022 FDEE. All rights reserved.
//

import Foundation
import FirebaseFirestore

class FirestoreManager {
    static let shared = FirestoreManager()
    private init() { }
    
    let db = Firestore.firestore()
}
