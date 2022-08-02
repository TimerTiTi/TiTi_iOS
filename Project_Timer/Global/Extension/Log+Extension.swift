//
//  Log+Extension.swift
//  Project_Timer
//
//  Created by 최수정 on 2022/08/02.
//  Copyright © 2022 FDEE. All rights reserved.
//

import Foundation

extension Log {
    init(dailys: [Daily]) {
        let yymm = Date().YYMMstyleInt
        self.totalTimeOfMonth = dailys.filter{ $0.day.YYMMstyleInt == yymm }.reduce(0, {$0 + $1.totalTime})
        
        let indexDayOfWeek = Date().indexDayOfWeek
        let weekFirstDate = Calendar.current.date(byAdding: .day, value: -indexDayOfWeek, to: Date()) ?? Date()
        let weekLastDate = Calendar.current.date(byAdding: .day, value: 7, to: weekFirstDate) ?? Date()
        self.totalTimeOfWeek = dailys
                                .filter { $0.day >= weekFirstDate && $0.day < weekLastDate}
                                .reduce(0, { $0 + $1.totalTime })
    }
}
