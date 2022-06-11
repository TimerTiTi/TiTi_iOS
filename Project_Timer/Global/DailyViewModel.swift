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
    
    func totalStudyTimeofMonth(month: Int, completion: @escaping (Int) -> ()) {
        let monthData = dailys.filter { $0.day.month == month }
        completion(monthData.reduce(0, { $0 + $1.totalTime }))
    }
    
    func totalAndMontylySumTime(completion: @escaping (Int, Int) -> ()) {
        let yymm = Date().YYMMstyleInt
        var total: Int = 0
        var monthly: Int = 0
        
        dailys.forEach { daily in
            total += daily.totalTime
            if daily.day.YYMMstyleInt == yymm {
                monthly += daily.totalTime
            }
        }
        completion(total, monthly)
    }
}
