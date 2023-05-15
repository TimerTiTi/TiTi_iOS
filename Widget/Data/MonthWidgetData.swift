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
    enum Color: Int, Codable {
        case D1 = 1
        case D2
        case D3
        case D4
        case D5
        case D6
        case D7
        case D8
        case D9
        case D10
        case D11
        case D12
    }
    var url: URL = URL(string: "/Log")!
    var now: Date = Date()
    
    let color: Color // 위젯 컬러
    let isRightDirection: Bool // 컬러 방향
    let tasksData: [MonthWidgetTaskData] // 상위 5가지 Task 데이터
    let cellsData: [MonthWidgetCellData] // 기록한 날짜, 누적시간 데이터
}
