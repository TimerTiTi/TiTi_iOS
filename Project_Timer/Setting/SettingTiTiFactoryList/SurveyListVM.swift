//
//  SurveyListVM.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2022/06/05.
//  Copyright © 2022 FDEE. All rights reserved.
//

import Foundation
import Combine

final class SurveyListVM {
    @Published private(set) var infos: [SurveyInfo] = []
    
    init() {
        self.configureInfos()
    }
    
    private func configureInfos() {
        FirestoreManager.shared.db.collection("surveys").getDocuments { [weak self] querySnapshot, error in
            if let error = error {
                print("Error getting documents: \(error)")
            } else {
                self?.infos = querySnapshot!.documents.map { SurveyInfo(data: $0.data()) }
            }
        }
    }
}
