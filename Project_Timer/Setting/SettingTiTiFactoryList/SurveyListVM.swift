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
        var infos: [SurveyInfo] = []
        infos.append(SurveyInfo(title: "휴식알림 기능", url: "https://forms.gle/mgkJupspCpA9PvKi7"))
        self.infos = infos
    }
}
