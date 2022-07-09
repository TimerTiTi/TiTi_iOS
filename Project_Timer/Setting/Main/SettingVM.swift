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
        self.sectionTitles.append("Version & Update history".localized())
        self.sectionTitles.append("Developer".localized())
    }
    
    private func configureCells() {
        // 앱 소개
        var cells0: [SettingCellInfo] = []
        cells0.append(SettingCellInfo(title: "TiTi Functions".localized(), nextVCIdentifier: SettingFunctionsListVC.identifier))
        cells0.append(SettingCellInfo(title: "TiTi Lab".localized(), nextVCIdentifier: SettingTiTiLabVC.identifier))
        // 알림 설정
        var cells1: [SettingCellInfo] = []
        cells1.append(SettingCellInfo(title: "Timer".localized(), subTitle: "5 minutes before, and End time".localized(), toggleKey: .timerPushable))
        cells1.append(SettingCellInfo(title: "Stopwatch".localized(), subTitle: "Every 1 hour passed".localized(), toggleKey: .stopwatchPushable))
//        cells2.append(SettingCellInfo(title: "휴식", subTitle: "5분단위 경과시 알림", toggleKey: .restPushable))
        cells1.append(SettingCellInfo(title: "Update".localized(), subTitle: "Pop-up alert for New version".localized(), toggleKey: .updatePushable))
        // UI 설정
        var cells2: [SettingCellInfo] = []
        cells2.append(SettingCellInfo(title: "Times Display".localized(), subTitle: "Smoothly display time changes".localized(), toggleKey: .timelabelsAnimation))
        // 버전 및 업데이트 내역
        var cells3: [SettingCellInfo] = []
        let versionCell = SettingCellInfo(title: "Version Info".localized(), subTitle: "Latest version".localized()+":", rightTitle: String.currentVersion, link: NetworkURL.appstore)
        versionCell.fetchVersion()
        cells3.append(versionCell)
        cells3.append(SettingCellInfo(title: "Update history".localized(), nextVCIdentifier: SettingUpdateHistoryVC.identifier))
        // 개발자
        var cells4: [SettingCellInfo] = []
        cells4.append(SettingCellInfo(title: "FDEE"))
        self.cells = [cells0, cells1, cells2, cells3, cells4]
    }
}
