//
//  SettingUpdateHistoryVM.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2022/06/04.
//  Copyright © 2022 FDEE. All rights reserved.
//

import Foundation
import Combine

final class SettingUpdateHistoryVM {
    let networkController: UpdateHistoryFetchable
    @Published private(set) var infos: [UpdateInfo] = []
    @Published private(set) var warning: (title: String, text: String)?
    
    init(networkController: UpdateHistoryFetchable) {
        self.networkController = networkController
        self.configureInfos()
    }
    
    private func configureInfos() {
        self.networkController.getUpdateHistorys { [weak self] result in
            switch result {
            case .success(let updateInfo):
                self?.infos = updateInfo.sorted(by: {
                    $0.version.value.compare($1.version.value, options: .numeric) == .orderedDescending
                })
            case .failure(let error):
                self?.warning = error.alertMessage
            }
        }
    }
}
