//
//  MonthTime.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2022/09/06.
//  Copyright © 2022 FDEE. All rights reserved.
//

import Foundation

struct MonthTime {
    let totalTime: Int
    let maxTime: Int
    let colorIndex: Int
    
    init(baseDate: Date = Date(), dailys: [Daily]) {
        let baseYYMM = baseDate.YYMMstyleInt
        self.totalTime = dailys.filter{ $0.day.YYMMstyleInt == baseYYMM }.reduce(0, {$0 + $1.totalTime})
        self.maxTime = UserDefaultsManager.get(forKey: .goalTimeOfMonth) as? Int ?? 360000
        self.colorIndex = UserDefaultsManager.get(forKey: .startColor) as? Int ?? 1
    }
}
