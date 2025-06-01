//
//  LogVM.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2022/03/14.
//  Copyright © 2022 FDEE. All rights reserved.
//

import Foundation
import Combine

final class LogHomeVM: ObservableObject {
    @Published private(set) var dailys: [Daily] = []
    @Published private(set) var daily: Daily?
    @Published private(set) var weekDates: [Date] = []
    @Published private(set) var totalTime: TotalTime?
    @Published private(set) var monthTime: MonthTime?
    @Published private(set) var weekSmallTime: WeekSmallTime?
    @Published var weekTime: WeekTime?
    private var cancellables = Set<AnyCancellable>()
    
    var totalVM: TotalVM?
    var monthSmallVM: MonthSmallVM?
    var weekSmallVM: WeekSmallVM?
    var monthVM: MonthVM?
    var weekVM: WeekVM?
    var dailyVM: DailyVM?

    private var subjectTimes: [Int] = []
    private var subjectNameTimes: [(name: String, time: String)] = []
    
    init() {
        self.totalVM = TotalVM(parent: self)
        self.monthVM = MonthVM(parent: self)
        self.monthSmallVM = MonthSmallVM(parent: self)
        self.weekSmallVM = WeekSmallVM(parent: self)
        self.weekVM = WeekVM(parent: self)
        self.dailyVM = DailyVM(parent: self)
    }

    public func update() {
        self.updateDailys()
        self.updateDaily()
        self.updateWeekDates()

        // 전체 데이터
        self.totalTime = TotalTime(dailys: self.dailys)
        // 오늘 기준 이번달
        self.monthTime = MonthTime(baseDate: Date(), dailys: self.dailys)
        // 오늘 기준 이번주
        self.weekSmallTime = WeekSmallTime(weekDates: self.weekDates, dailys: self.dailys)
        // 오늘 기준 이번주
        self.weekTime = WeekTime(weekDates: self.weekDates, dailys: self.dailys)
    }

    public func updateColor() {
        self.totalVM?.updateColor()
        self.monthSmallVM?.updateColor()
        self.weekSmallVM?.updateColor()
        self.monthVM?.updateColor()
        self.weekVM?.updateColor()
        self.dailyVM?.updateColor()
    }
}

extension LogHomeVM {
    private func updateDailys() {
        // 전체 데이터
        self.dailys = RecordsManager.shared.dailyManager.dailys
    }
    
    private func updateDaily() {
        // 기록중인 daily 기준
        self.daily = RecordsManager.shared.dailyManager.currentDaily
    }

    private func updateWeekDates() {
        // 오늘 기준
        let baseDate = Date().zeroDate.localDate
        let indexDayOfWeek = baseDate.indexDayOfWeek
        let mon = Calendar.current.date(byAdding: .day, value: -indexDayOfWeek, to: baseDate) ?? Date()
        self.weekDates = (0...6).compactMap { Calendar.current.date(byAdding: .day, value: $0, to: mon)}
    }
}
