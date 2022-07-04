//
//  UpdateHistoryVM.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2022/06/04.
//  Copyright © 2022 FDEE. All rights reserved.
//

import Foundation
import Combine

final class UpdateHistoryVM {
    let networkController: UpdateInfosFetchable
    @Published private(set) var infos: [UpdateInfo] = []
    @Published private(set) var warning: (title: String, text: String)?
    
    init(networkController: UpdateInfosFetchable) {
        self.networkController = networkController
        self.configureInfos()
    }
    
    private func configureInfos() {
        self.networkController.getUpdateInfos { [weak self] status, infos in
            switch status {
            case .SUCCESS:
                self?.infos = infos.sorted(by: {
                    $0.version.value.compare($1.version.value, options: .numeric) == .orderedDescending
                })
            case .DECODEERROR:
                self?.warning = (title: "네트워크 에러", text: "최신 버전으로 업데이트 해주세요")
            default:
                self?.warning = (title: "네트워크 에러", text: "네트워크를 확인 후 다시 시도해주세요")
            }
        }
    }
}
