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
        self.totalTime = dailys.filter { daily in
            daily.day >= weekDates[0] && daily.day < weekDates[6]
        }.reduce(0, { $0 + $1.totalTime })
        self.maxTime = UserDefaultsManager.get(forKey: .goalTimeOfWeek) as? Int ?? 90000
        self.colorIndex = UserDefaultsManager.get(forKey: .startColor) as? Int ?? 1
    }
}
