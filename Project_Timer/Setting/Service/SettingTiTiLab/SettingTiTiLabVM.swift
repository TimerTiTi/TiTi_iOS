//
//  SettingTiTiLabVM.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2022/06/05.
//  Copyright © 2022 FDEE. All rights reserved.
//

import Foundation
import Combine

final class SettingTiTiLabVM {
    let networkController: SurveysFetchable
    @Published private(set) var infos: [SurveyInfo] = []
    @Published private(set) var warning: (title: String, text: String)?
    
    init(networkController: SurveysFetchable) {
        self.networkController = networkController
        self.configureInfos()
    }
    
    private func configureInfos() {
        self.networkController.getSurveys { [weak self] status, infos in
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
}
