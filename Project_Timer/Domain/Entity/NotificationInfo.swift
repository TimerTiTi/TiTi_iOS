//
//  NotificationInfo.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2023/12/16.
//  Copyright © 2023 FDEE. All rights reserved.
//

import Foundation

struct NotificationInfo {
    var title: String
    var text: String
    var notis: [NotificationDateInfo]
}

struct NotificationDateInfo: Hashable {
    var title: String
    var date: Date
}

extension NotificationInfo {
    static var testInfo: NotificationInfo {
        return .init(
            title: "서버 이전작업에 따른\n서비스 이용 일시 중단안내",
            text: """
안녕하세요. TimerTiTi 개발팀입니다.

현재 운영 중인 서버 이전 작업으로 기록 동기화
(Sync Dailys) 기능이 잠시 제한될 예정입니다.
작업 시간 동안에는 동기화 기능이 제한되므로
미리 기록 동기화를 진행해 주시길 바랍니다.

사용자분들은 이용에 참고 부탁드립니다.
""",
            notis: [
                .init(
                    title: "중단 일시",
                    date: Calendar.current.date(byAdding: .day, value: 7, to: Date())!
                ),
                .init(
                    title: "중단 일시",
                    date: Calendar.current.date(byAdding: .day, value: 7, to: Date())!
                )
            ]
        )
    }
}
