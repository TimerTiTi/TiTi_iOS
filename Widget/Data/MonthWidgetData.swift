//
//  MonthWidgetData.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2023/05/12.
//  Copyright © 2023 FDEE. All rights reserved.
//

import Foundation

struct MonthWidgetData: Codable {
    static let fileName = "MonthWidgetData.json"
    var url: URL = URL(string: "/Log")!
    var now: Date = Date()
    
    let color: Int // 위젯 컬러
    let isReverseColor: Bool // 컬러 방향
    let tasksData: [MonthWidgetTaskData] // 상위 5가지 Task 데이터
    let cellsData: [MonthWidgetCellData] // 기록한 날짜, 누적시간 데이터
}
