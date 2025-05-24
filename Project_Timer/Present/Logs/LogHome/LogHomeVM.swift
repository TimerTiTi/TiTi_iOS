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
    private var subjectTimes: [Int] = []
    private var subjectNameTimes: [(name: String, time: String)] = []
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
    
    init() {
        self.totalVM = TotalVM()
        self.monthSmallVM = MonthSmallVM()
        self.weekSmallVM = WeekSmallVM()
        self.monthVM = MonthVM()
        self.weekVM = WeekVM()
        self.dailyVM = DailyVM()
    }
    
    func updateDailys() {
        self.dailys = RecordsManager.shared.dailyManager.dailys
    }
    
    func loadDaily() {
        self.daily = RecordsManager.shared.dailyManager.currentDaily
    }
    
    func updateColor() {
        self.totalVM.updateColor()
        self.monthSmallVM.updateColor()
        self.weekSmallVM.updateColor()
        self.monthVM.updateColor()
        self.weekVM.updateColor()
        self.dailyVM.updateColor()
    }
}

extension LogHomeVM {
    private func updateTotal() {
        self.totalVM.update(totalTime: TotalTime(dailys: self.dailys))
    }
    
    private func updateMonth() {
        let monthTime = MonthTime(baseDate: Date(), dailys: self.dailys)
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
        let baseDate = Date().zeroDate.localDate
        let indexDayOfWeek = baseDate.indexDayOfWeek
        let mon = Calendar.current.date(byAdding: .day, value: -indexDayOfWeek, to: baseDate) ?? Date()
        self.weekDates = (0...6).compactMap { Calendar.current.date(byAdding: .day, value: $0, to: mon)}
    }
}
