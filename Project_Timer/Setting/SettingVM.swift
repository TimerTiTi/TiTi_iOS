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
    }
    
    private func configureCells() {
        // 앱 소개
        var cells1: [SettingCellInfo] = []
        cells1.append(SettingCellInfo(title: "TiTi 기능들",
                                      subTitle: nil,
                                      rightTitle: nil,
                                      touchable: true,
                                      switchable: false))
        cells1.append(SettingCellInfo(title: "TiTi 연구소",
                                      subTitle: nil,
                                      rightTitle: nil,
                                      touchable: true,
                                      switchable: false))
        // 알림 설정
        var cells2: [SettingCellInfo] = []
        cells2.append(SettingCellInfo(title: "타이머",
                                      subTitle: "종료 5분전, 종료시 알림",
                                      rightTitle: nil,
                                      touchable: false,
                                      switchable: true))
        cells2.append(SettingCellInfo(title: "스톱워치",
                                      subTitle: "1시간단위 경과시 알림",
                                      rightTitle: nil,
                                      touchable: false,
                                      switchable: true))
        cells2.append(SettingCellInfo(title: "휴식",
                                      subTitle: "5분단위 경과시 알림",
                                      rightTitle: nil,
                                      touchable: false,
                                      switchable: true))
        cells2.append(SettingCellInfo(title: "업데이트",
                                      subTitle: "최신버전이 아닐시 알림",
                                      rightTitle: nil,
                                      touchable: false,
                                      switchable: true))
        // 버전 및 업데이트 내역
        var cells3: [SettingCellInfo] = []
        cells3.append(SettingCellInfo(title: "버전 정보",
                                      subTitle: "최신버전: 6.5.3",
                                      rightTitle: String.currentVersion,
                                      touchable: true,
                                      switchable: false))
        cells3.append(SettingCellInfo(title: "업데이트 내역",
                                      subTitle: nil,
                                      rightTitle: nil,
                                      touchable: true,
                                      switchable: false))
        // 개발자
        self.cells = [cells1, cells2, cells3]
    }
    
}
