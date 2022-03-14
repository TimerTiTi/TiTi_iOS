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
    
    func totalStudyTimeofMonth(month: Int, completion: @escaping (Int) -> ()) {
        let monthData = dailys.filter { self.getMonth($0.day) == month }
        monthData.forEach { print("\($0.day): \($0.currentSumTime.toTimeString)")}
        completion(dailys.filter { self.getMonth($0.day) == month }.reduce(0, { $0 + dailyTotalTime($1.tasks) }))
    }
    
    func totalStudyTimeOfMonth(completion: @escaping (Int) -> ()) {
        let month = self.getMonth(Date())
        completion(dailys.filter { self.getMonth($0.day) == month }.reduce(0, { $0 + dailyTotalTime($1.tasks) }))
    }
    
    func dailyTotalTime(_ tasks: [String:Int]) -> Int {
        return tasks.values.reduce(0, +)
    }
    
    private func getMonth(_ date: Date) -> Int {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM"
        let month = dateFormatter.string(from: date)
        return Int(month) ?? 0
    }
    
}
