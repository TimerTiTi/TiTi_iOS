//
//  MonthWidgetEntry.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2023/05/11.
//  Copyright © 2023 FDEE. All rights reserved.
//

import Foundation
import WidgetKit

// MARK: MonthWidget 표시를 위한 데이터 부분
struct MonthWidgetEntry: TimelineEntry {
    let date: Date
    let data: MonthWidgetData
    
    init(data: MonthWidgetData) {
        self.date = Date()
        self.data = data
    }
    
    init(date: Date, data: MonthWidgetData) {
        self.date = date
        self.data = data
    }
}