//
//  WeekSmallTime.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2022/09/06.
//  Copyright © 2022 FDEE. All rights reserved.
//

import Foundation

struct WeekSmallTime {
    let totalTime: Int
    let maxTime: Int
    let colorIndex: Int
    
    init(weekDates: [Date], dailys: [Daily]) {
        let weekLastDate = Calendar.current.date(byAdding: .day, value: 7, to: weekDates[0]) ?? Date()
        self.totalTime = dailys.filter { daily in
            daily.day.zeroDate.localDate >= weekDates[0] && daily.day.zeroDate.localDate < weekLastDate
        }.reduce(0, { $0 + $1.totalTime })
        self.maxTime = UserDefaultsManager.get(forKey: .goalTimeOfWeek) as? Int ?? 90000
        self.colorIndex = UserDefaultsManager.get(forKey: .startColor) as? Int ?? 1
    }
}
