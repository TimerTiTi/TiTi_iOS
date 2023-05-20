//
//  SettingNotificationVM.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2023/05/20.
//  Copyright © 2023 FDEE. All rights reserved.
//

import Foundation

final class SettingNotificationVM {
    let cells: [SettingListCellInfo]
    
    init() {
        self.cells = [
            SettingListCellInfo(title: "Timer".localized(), subTitle: "5 minutes before end".localized(), toggleKey: .timer5minPushable),
            SettingListCellInfo(title: "Timer".localized(), subTitle: "Ended".localized(), toggleKey: .timerPushable),
            SettingListCellInfo(title: "Stopwatch".localized(), subTitle: "Every 1 hour passed".localized(), toggleKey: .stopwatchPushable),
            SettingListCellInfo(title: "Update".localized(), subTitle: "Pop-up alert for New version".localized(), toggleKey: .updatePushable)
        ]
    }
}
