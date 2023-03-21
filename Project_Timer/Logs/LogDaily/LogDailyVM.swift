//
//  LogDailyVM.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2022/07/24.
//  Copyright © 2022 FDEE. All rights reserved.
//

import Foundation

final class LogDailyVM {
    /* public */
    @Published private(set) var currentDaily: Daily?
    @Published private(set) var tasks: [TaskInfo] = []
    let timelineVM: TimelineVM
    let timeTableVM: TimeTableVM
    var selectedDate: Date = Date().zeroDate
    
    init() {
        self.timelineVM = TimelineVM()
        self.timeTableVM = TimeTableVM()
    }
    
    func updateDaily(to daily: Daily?) {
        self.currentDaily = daily
        self.timelineVM.update(daily: daily)
        if let tasks = daily?.tasks {
            self.tasks = tasks.sorted(by: { $0.value > $1.value })
                .map { TaskInfo(taskName: $0.key, taskTime: $0.value) }
        } else {
            self.tasks = []
        }
        
        self.timeTableVM.update(daily: daily, tasks: self.tasks)
    }
    
    func updateCurrentDaily() {
        let newDaily = RecordsManager.shared.dailyManager.dailys.first(where: { $0.day.zeroDate == self.selectedDate })
        self.updateDaily(to: newDaily)
    }
    
    func updateColor() {
        self.timelineVM.updateColor()
        self.timeTableVM.updateColor()
    }
}
