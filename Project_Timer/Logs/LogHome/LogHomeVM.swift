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
    @Published private(set) var daily: Daily = Daily()
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
    
    init() {
        self.totalVM = TotalVM()
        self.monthSmallVM = MonthSmallVM()
        self.weekSmallVM = WeekSmallVM()
        self.monthVM = MonthVM()
        self.weekVM = WeekVM()
    }
    
    func updateDailys() {
        self.dailys = RecordController.shared.dailys.dailys
    }
    
    func loadDaily() {
        self.daily = RecordController.shared.daily
        self.configureSubjectNameTimes()
    }
    
    func updateColor() {
        self.totalVM.updateColor(isReverseColor: false)
        self.monthSmallVM.updateColor()
        self.weekSmallVM.updateColor()
        self.monthVM.updateColor(isReverseColor: false)
    }
    
    private func configureSubjectNameTimes() {
        let tasks = self.daily.tasks.sorted(by: { $0.value < $1.value } )
        self.subjectNameTimes = tasks.map { ($0.key, $0.value.toTimeString) }
        self.subjectTimes = tasks.map (\.value)
    }
}

extension LogHomeVM {
    private func updateTotal() {
        self.totalVM.update(totalTime: TotalTime(dailys: self.dailys, isReverseColor: false))
    }
    
    private func updateMonth() {
        let monthTime = MonthTime(baseDate: Date(), dailys: self.dailys, isReverseColor: false)
        self.monthSmallVM.update(monthTime: monthTime)
        self.monthVM.update(monthTime: monthTime)
    }
    
    private func updateWeekSmall() {
        self.weekSmallVM.update(weekSmallTime: WeekSmallTime(weekDates: self.weekDates, dailys: self.dailys))
    }
    
    private func updateWeek() {
        self.weekVM.update(weekTime: WeekTime(weekDates: self.weekDates, dailys: self.dailys, isReverseColor: false))
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
