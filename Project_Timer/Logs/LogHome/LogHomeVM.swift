//
//  LogVM.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2022/03/14.
//  Copyright © 2022 FDEE. All rights reserved.
//

import Foundation
import Combine

final class LogHomeVM {
    @Published private(set) var daily: Daily = Daily() {
        didSet {
            self.updateDaily()
        }
    }
    @Published private(set) var subjectTimes: [Int] = []
    @Published private(set) var subjectNameTimes: [(name: String, time: String)] = []
    private var dailys: [Daily] = [] {
        didSet {
            self.updateTotal()
            self.updateWeekDates()
            self.updateMonth()
            self.updateMonth()
        }
    }
    private var weekDates: [Date] = [] {
        didSet {
            self.updateWeekSmall()
            self.updateWeek()
        }
    }
    let totalVM: TotalVM
    let monthSmallVM: MonthSmallVM
    let weekSmallVM: WeekSmallVM
    let monthVM: MonthVM
    let weekVM: WeekVM
    let dailyVM: DailyVM
    // MARK: 임시 로직 (
    private var dayOffset: Int = 0 {
        didSet {
            self.loadDaily()
            self.updateDailys()
        }
    }
    
    init() {
        self.totalVM = TotalVM()
        self.monthSmallVM = MonthSmallVM()
        self.weekSmallVM = WeekSmallVM()
        self.monthVM = MonthVM()
        self.weekVM = WeekVM()
        self.dailyVM = DailyVM()
    }
    
    func updateDailys() {
        self.dailys = RecordController.shared.dailys.dailys
    }
    
    func loadDaily() {
        let dailys = RecordController.shared.dailys
        let currentDaily = RecordController.shared.daily
        if let targetIndex = dailys.dates.firstIndex(of: currentDaily.day.zeroDate) {
            var index = max(0, targetIndex+dayOffset)
            index = min(dailys.dailys.count-1, index)
            self.daily = dailys.dailys[index]
        } else {
            self.daily = RecordController.shared.daily
        }
    }
    
    func updateColor() {
        self.totalVM.updateColor()
        self.monthSmallVM.updateColor()
        self.weekSmallVM.updateColor()
        self.monthVM.updateColor()
        self.weekVM.updateColor()
        self.dailyVM.updateColor()
    }
    
    // MARK: 임시 로직 (날짜 이동)
    func previewDay() {
        self.dayOffset -= 1
    }
    
    func nextDay() {
        self.dayOffset += 1
    }
}

extension LogHomeVM {
    private func updateTotal() {
        self.totalVM.update(totalTime: TotalTime(dailys: self.dailys))
    }
    
    private func updateMonth() {
        let baseDate = self.daily.day.zeroDate.localDate
        let monthTime = MonthTime(baseDate: baseDate, dailys: self.dailys)
        self.monthSmallVM.update(monthTime: monthTime)
        self.monthVM.update(monthTime: monthTime)
    }
    
    private func updateWeekSmall() {
        self.weekSmallVM.update(weekSmallTime: WeekSmallTime(weekDates: self.weekDates, dailys: self.dailys))
    }
    
    private func updateWeek() {
        self.weekVM.update(weekTime: WeekTime(weekDates: self.weekDates, dailys: self.dailys))
    }
    
    private func updateDaily() {
        self.dailyVM.update(daily: self.daily)
    }
}

extension LogHomeVM {
    private func updateWeekDates() {
        let baseDate = self.daily.day.zeroDate.localDate
        let indexDayOfWeek = baseDate.indexDayOfWeek
        let mon = Calendar.current.date(byAdding: .day, value: -indexDayOfWeek, to: baseDate) ?? Date()
        self.weekDates = (0...6).compactMap { Calendar.current.date(byAdding: .day, value: $0, to: mon)}
    }
}
