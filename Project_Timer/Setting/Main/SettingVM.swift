//
//  SettingVM.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2022/06/01.
//  Copyright © 2022 FDEE. All rights reserved.
//

import Foundation
import Combine

final class SettingVM {
    @Published private(set) var cells: [[SettingCellInfo]] = []
    private(set) var sectionTitles: [String] = []
    
    init() {
        self.configureTitles()
        self.configureCells()
    }
    
    private func configureTitles() {
        self.sectionTitles.append("Introducing app".localized())
        self.sectionTitles.append("Notification".localized())
        self.sectionTitles.append("UI")
        self.sectionTitles.append("Control")
        self.sectionTitles.append("Version & Update history".localized())
        self.sectionTitles.append("Developer".localized())
    }
    
    private func configureCells() {
        let versionCell = SettingCellInfo(title: "Version Info".localized(), subTitle: "Latest version".localized()+":", rightTitle: String.currentVersion, link: NetworkURL.appstore)
        versionCell.fetchVersion()
        self.cells = [
            [
                SettingCellInfo(title: "TiTi Functions".localized(), nextVCIdentifier: SettingFunctionsListVC.identifier),
                SettingCellInfo(title: "TiTi Lab".localized(), nextVCIdentifier: SettingTiTiLabVC.identifier)
            ],
            [
                SettingCellInfo(title: "Timer".localized(), subTitle: "5 minutes before, and End time".localized(), toggleKey: .timerPushable),
                SettingCellInfo(title: "Stopwatch".localized(), subTitle: "Every 1 hour passed".localized(), toggleKey: .stopwatchPushable),
                SettingCellInfo(title: "Update".localized(), subTitle: "Pop-up alert for New version".localized(), toggleKey: .updatePushable)
            ],
            [
                SettingCellInfo(title: "Times Display".localized(), subTitle: "Smoothly display time changes".localized(), toggleKey: .timelabelsAnimation)
            ],
            [
                SettingCellInfo(title: "Keep screen on".localized(), subTitle: "Keep the screen on during recording".localized(), toggleKey: .keepTheScreenOn),
                SettingCellInfo(title: "Flip to start recording".localized(), subTitle: "Record will be start automatically when flip the device".localized(), toggleKey: .dimWhenFaceDown)
            ],
            [
                versionCell,
                SettingCellInfo(title: "Update history".localized(), nextVCIdentifier: SettingUpdateHistoryVC.identifier)
            ],
            [
                SettingCellInfo(title: "FDEE")
            ]
        ]
    }
}
