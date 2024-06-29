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
        self.networkController.getSurveys_lagacy { [weak self] result in
            switch result {
            case .success(let surveyInfos):
                self?.infos = surveyInfos
            case .failure(let error):
                self?.warning = error.alertMessage
            }
        }
    }
}
