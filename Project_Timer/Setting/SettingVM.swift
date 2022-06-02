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
        self.sectionTitles.append("앱 소개")
        self.sectionTitles.append("알림 설정")
        self.sectionTitles.append("버전 및 업데이트 내역")
        self.sectionTitles.append("개발자")
    }
    
    private func configureCells() {
        // 앱 소개
        var cells1: [SettingCellInfo] = []
        cells1.append(SettingCellInfo(title: "TiTi 기능들", nextVCIdentifier: "SettingFunctionsListVC"))
        cells1.append(SettingCellInfo(title: "TiTi 연구소", nextVCIdentifier: "SettingTiTiFactoryListVC"))
        // 알림 설정
        var cells2: [SettingCellInfo] = []
        cells2.append(SettingCellInfo(title: "타이머", subTitle: "종료 5분전, 종료시 알림", toggleKey: .timerPushable))
        cells2.append(SettingCellInfo(title: "스톱워치", subTitle: "1시간단위 경과시 알림", toggleKey: .stopwatchPushable))
        cells2.append(SettingCellInfo(title: "휴식", subTitle: "5분단위 경과시 알림", toggleKey: .restPushable))
        cells2.append(SettingCellInfo(title: "업데이트", subTitle: "최신버전 업데이트 알림", toggleKey: .updatePushable))
        // 버전 및 업데이트 내역
        var cells3: [SettingCellInfo] = []
        cells3.append(SettingCellInfo(title: "버전 정보", subTitle: "최신버전: 6.5.3", rightTitle: String.currentVersion, link: NetworkURL.appstore))
        cells3.append(SettingCellInfo(title: "업데이트 내역", nextVCIdentifier: "SettingUpdatesListVC"))
        // 개발자
        var cells4: [SettingCellInfo] = []
        cells4.append(SettingCellInfo(title: "FDEE"))
        self.cells = [cells1, cells2, cells3, cells4]
    }
}
