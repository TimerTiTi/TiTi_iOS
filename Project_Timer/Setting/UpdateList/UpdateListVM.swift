//
//  UpdateListVM.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2022/06/04.
//  Copyright © 2022 FDEE. All rights reserved.
//

import Foundation
import Combine

final class UpdateListVM {
    @Published private(set) var infos: [UpdateInfo] = []
    
    init() {
        self.configureInfos()
    }
    
    private func configureInfos() {
        var infos: [UpdateInfo] = []
        infos.append(UpdateInfo(version: "6.5.3", date: "2022.06.02", text:"Log 창의 month 값의 계산 로직을 수정하였습니다.\n기타 버그를 해결하고 UI를 개선하였습니다."))
        infos.append(UpdateInfo(version: "6.5.2", date: "2022.05.27", text: "기록날짜 확인을 위한 기능이 추가되었습니다"))
        infos.append(UpdateInfo(version: "6.5.1", date: "2022.05.21", text: "아이패드 사용자의 화면전환 로직을 수정하였습니다.\n새 버전 업데이트 팝업로직을 추가하였습니다."))
        infos.append(UpdateInfo(version: "6.5", date: "2022.05.18", text: "기록 안정화 작업: 앱 종료상태와 상관없이 기록이 진행됩니다.\n앱 Badge 숫자: 기록 진행중일 경우 1로 표시됩니다.\n타이머 Notification: 종료 5분전, 종료시각 시 알림이 동작됩니다.\n스탑워치 Notification: 1시간단위 경과시 알림이 동작됩니다."))
        self.infos = infos
    }
}
