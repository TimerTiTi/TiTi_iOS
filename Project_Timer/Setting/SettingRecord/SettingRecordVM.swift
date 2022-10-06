//
//  SettingRecordVM.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2022/10/06.
//  Copyright © 2022 FDEE. All rights reserved.
//

import Foundation
import Combine


final class SettingRecordVM {
    @Published private(set) var cellInfos: [SettingRecordCellInfo] = []
    
    init() {
        self.configureCellInfos()
    }
    
    private func configureCellInfos() {
        self.cellInfos = [
            SettingRecordCellInfo(titleText: "Month", subTitleText: "Target time of Month's Total Time".localized(), key: .goalTimeOfMonth),
            SettingRecordCellInfo(titleText: "Week", subTitleText: "Target time of Week's Total Time".localized(), key: .goalTimeOfWeek),
            SettingRecordCellInfo(titleText: "Daily", subTitleText: "Target time of daily's Total Time".localized(), key: .goalTimeOfDaily)
        ]
    }
}
