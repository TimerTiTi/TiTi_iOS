//
//  FunctionInfoListVM.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2022/06/05.
//  Copyright © 2022 FDEE. All rights reserved.
//

import Foundation
import Combine
import FirebaseFirestore

final class FunctionInfoListVM {
    @Published private(set) var infos: [FunctionInfo] = []
    
    init() {
        self.configureInfos()
    }
    
    private func configureInfos() {
        FirestoreManager.shared.db.collection("titifuncs").getDocuments { querySnapshot, error in
            if let error = error {
                print("Error getting documents: \(error)")
            } else {
                self.infos = querySnapshot!.documents.map { FunctionInfo(data: $0.data()) }
            }
        }
    }
}
