//
//  WeekTime.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2022/09/13.
//  Copyright © 2022 FDEE. All rights reserved.
//

import Foundation

struct WeekTime {
    let weekDates: [Date]
    let weekNum: Int
    var dailys: [Daily?] = Array(repeating: nil, count: 7)
    let totalTime: Int
    let averageTime: Int
    let colorIndex: Int
    let reverseColor: Bool
    
    init(weekDates: [Date], dailys: [Daily]) {
        self.weekDates = weekDates
        self.weekNum = weekDates.map(\.weekOfMonth).min() ?? 0
        let filteredDailys = dailys.filter { daily in
            daily.day >= weekDates[0] && daily.day < weekDates[6]
        }
        self.totalTime = filteredDailys.reduce(0, { $0 + $1.totalTime })
        self.averageTime = filteredDailys.count != 0 ? self.totalTime/filteredDailys.count : 0
        self.colorIndex = UserDefaultsManager.get(forKey: .startColor) as? Int ?? 1
        self.reverseColor = UserDefaultsManager.get(forKey: .reverseColor) as? Bool ?? false
        filteredDailys.forEach { daily in
            self.dailys[daily.day.indexDayOfWeek] = daily
        }
    }
}
