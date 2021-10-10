//
//  DailyViewModel.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2021/06/29.
//  Copyright © 2021 FDEE. All rights reserved.
//

import Foundation

class DailyViewModel {
    
    private let manager = DailyManager.shared
    
    var dailys: [Daily] {
        return manager.dailys
    }
    
    var dates: [Date] {
        return manager.dates
    }
    
    func addDaily(_ daily: Daily) {
        manager.addDaily(daily)
    }
    
    func loadDailys() {
        manager.loadDailys()
    }
    
    func totalStudyTimeOfAll() -> Int {
        return dailys.reduce(0, { $0 + $1.currentSumTime })
    }
    
    func totalStudyTimeofMonth(month: Int) -> Int {
        return dailys.filter { ViewManager.getMonth($0.day) == month }.reduce(0, { $0 + $1.currentSumTime })
    }
    
    func totalStudyTimeOfMonth() -> Int {
        return dailys.filter { ViewManager.getMonth($0.day) == ViewManager.getMonth(Date()) }.reduce(0, { $0 + $1.currentSumTime })
    }
    
}
