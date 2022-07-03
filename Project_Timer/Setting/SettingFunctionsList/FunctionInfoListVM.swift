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
    private let networkController: TiTiFunctionsFetchable
    @Published private(set) var infos: [FunctionInfo] = []
    @Published private(set) var warning: (title: String, text: String)?
    private(set) var link: String?
    
    init(networkController: TiTiFunctionsFetchable) {
        self.networkController = networkController
        self.configureInfos()
        self.configureYoutubeLink()
    }
    
    private func configureInfos() {
        self.networkController.getTiTiFunctions { [weak self] status, infos in
            switch status {
            case .SUCCESS:
                self?.infos = infos
            case .DECODEERROR:
                self?.warning = (title: "네트워크 에러", text: "최신 버전으로 업데이트 해주세요")
            default:
                self?.warning = (title: "네트워크 에러", text: "네트워크를 확인 후 다시 시도해주세요")
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
