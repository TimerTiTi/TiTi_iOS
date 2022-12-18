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
    private let isIpad: Bool
    
    init(isIpad: Bool) {
        self.isIpad = isIpad
        self.configureTitles()
        self.configureCells()
    }
    
    private func configureTitles() {
        self.sectionTitles.append("Introducing app".localized())
        self.sectionTitles.append("Notification".localized())
        self.sectionTitles.append("UI")
        #if targetEnvironment(macCatalyst)
        #else
        self.sectionTitles.append("Control")
        #endif
        self.sectionTitles.append("Record")
        self.sectionTitles.append("Version & Update history".localized())
        self.sectionTitles.append("Backup")
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
                SettingCellInfo(title: "Timer".localized(), subTitle: "5 minutes before end".localized(), toggleKey: .timer5minPushable),
                SettingCellInfo(title: "Timer".localized(), subTitle: "Ended".localized(), toggleKey: .timerPushable),
                SettingCellInfo(title: "Stopwatch".localized(), subTitle: "Every 1 hour passed".localized(), toggleKey: .stopwatchPushable),
                SettingCellInfo(title: "Update".localized(), subTitle: "Pop-up alert for New version".localized(), toggleKey: .updatePushable)
            ],
            [
                SettingCellInfo(title: "Times Display".localized(), subTitle: "Smoothly display time changes".localized(), toggleKey: .timelabelsAnimation),
                SettingCellInfo(title: "Big UI", subTitle: "Activate Big UI for iPad".localized(), toggleKey: .bigUI),
                SettingCellInfo(title: "Theme color".localized(), subTitle: "Setting Graph's theme color".localized(), rightTitle: "", nextVCIdentifier: SettingColorVC.identifier)
            ],
            [
                SettingCellInfo(title: "Keep screen on".localized(), subTitle: "Keep the screen on during recording".localized(), toggleKey: .keepTheScreenOn),
                SettingCellInfo(title: "Flip to start recording".localized(), subTitle: "Record will start automatically when flip the device".localized(), toggleKey: .flipToStartRecording)
            ],
            [
                SettingCellInfo(title: "Target Times".localized(), subTitle: "Target times for graph in Log Home".localized(), rightTitle: "", nextVCIdentifier: SettingRecordVC.identifier)
            ],
            [
                versionCell,
                SettingCellInfo(title: "Update history".localized(), nextVCIdentifier: SettingUpdateHistoryVC.identifier)
            ],
            [
                SettingCellInfo(title: "Get stored JSON files".localized(), nextVCIdentifier: "showBackup")
            ],
            [
                SettingCellInfo(title: "FDEE")
            ]
        ]
        
        #if targetEnvironment(macCatalyst)
        self.cells.remove(at: 3)
        #else
        if self.isIpad == false {
            self.cells[2].remove(at: 1)
        }
        #endif
    }
}
