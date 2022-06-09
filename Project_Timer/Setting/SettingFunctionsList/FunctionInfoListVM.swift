//
//  FunctionInfoListVM.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2022/06/05.
//  Copyright © 2022 FDEE. All rights reserved.
//

import Foundation
import Combine

final class FunctionInfoListVM {
    @Published private(set) var infos: [FunctionInfo] = []
    private(set) var link: String?
    
    init() {
        self.configureInfos()
        self.configureYoutubeLink()
    }
    
    private func configureInfos() {
        FirestoreManager.shared.db.collection("titifuncs").getDocuments { [weak self] querySnapshot, error in
            if let error = error {
                print("Error getting documents: \(error)")
            } else {
                self?.infos = querySnapshot!.documents.map { FunctionInfo(data: $0.data()) }
            }
        }
    }
    
    private func configureYoutubeLink() {
        FirestoreManager.shared.db.collection("links").document("youtube").getDocument { [weak self] snapshot, error in
            if let error = error {
                print("Error getting documents: \(error)")
            } else {
                self?.link = snapshot?.data()?["url"] as? String
            }
        }
    }
}
