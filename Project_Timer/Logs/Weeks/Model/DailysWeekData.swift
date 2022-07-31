//
//  DailysWeekData.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2022/07/30.
//  Copyright © 2022 FDEE. All rights reserved.
//

import Foundation

struct DailysWeekData {
    private(set) var weekDates: [Date] = []
    private(set) var weekNum: Int = 0
    private(set) var dailys: [Daily?] = Array(repeating: nil, count: 7)
    private(set) var totalTime: Int = 0
    private(set) var averageTime: Int = 0
    private(set) var top5Tasks: [TaskInfo] = []
    private(set) var top5Time: Int = 0
    private var filteredDailys: [Daily] = []
    
    init(selectedDate: Date, dailys: [Daily]) {
        /// weekDates 설정
        let indexDayOfWeek = selectedDate.indexDayOfWeek // 선택된 날짜의 요일 index값
        print(Date(), selectedDate, indexDayOfWeek)
        let weekFirstDate = Calendar.current.date(byAdding: .day, value: -indexDayOfWeek, to: selectedDate) ?? Date() // 선택된 날짜를 포함하는 주의 월요일
        let weekLastDate = Calendar.current.date(byAdding: .day, value: 7, to: weekFirstDate) ?? Date() // 다음주간 월요일
        self.weekDates = (0...6).compactMap { Calendar.current.date(byAdding: .day, value: $0, to: weekFirstDate) } // 주의 월~일 날짜
        /// weekNum 설정
        self.weekNum = self.weekDates.map(\.weekOfMonth).min() ?? 0
        /// dailys 설정
        self.filteredDailys = dailys.filter { daily in
            daily.day >= weekFirstDate && daily.day < weekLastDate
        }
        self.filteredDailys.forEach { daily in
            self.dailys[daily.day.indexDayOfWeek] = daily
        }
        /// totalTime 설정
        self.totalTime = self.filteredDailys.reduce(0, { $0 + $1.totalTime })
        /// averageTime 설정
        self.averageTime = self.filteredDailys.count != 0 ? self.totalTime/self.filteredDailys.count : 0
        /// top5Tasks 설정
        var tasks: [String: Int] = [:]
        self.filteredDailys.forEach { daily in
            daily.tasks.forEach { key, value in
                if let sum = tasks[key] {
                    tasks[key] = sum+value
                } else {
                    tasks[key] = value
                }
            }
        }
        self.top5Tasks = Array(tasks.sorted { $0.value > $1.value }
            .map { TaskInfo(taskName: $0.key, taskTime: $0.value) }
            .prefix(5))
        /// top5Time 설정
        self.top5Time = self.top5Tasks.reduce(0, { $0 + $1.taskTime })
    }
}
