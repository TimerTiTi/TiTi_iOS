//
//  UpdateListVM.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2022/06/04.
//  Copyright © 2022 FDEE. All rights reserved.
//

import Foundation
import Combine

final class UpdateListVM {
    @Published private(set) var infos: [UpdateInfo] = []
    
    init() {
        self.configureInfos()
    }
    
    private func configureInfos() {
        FirestoreManager.shared.db.collection("updates").getDocuments { querySnapshot, error in
            if let error = error {
                print("Error getting documents: \(error)")
            } else {
                self.infos = querySnapshot!.documents.map { UpdateInfo(data: $0.data()) }
                    .sorted(by: {
                        $0.version.compare($1.version, options: .numeric) == .orderedDescending
                    })
            }
        }
    }
}
