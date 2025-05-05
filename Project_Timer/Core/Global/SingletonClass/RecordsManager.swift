//
//  RecordsManager.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2022/04/29.
//  Copyright © 2022 FDEE. All rights reserved.
//

import Foundation

final class RecordsManager {
    static let shared = RecordsManager()
    var dailyManager = DailyManager()
    var taskManager = TaskManager()
    var recordTimes = RecordTimes()
    var currentTask: Task?
    static var resetHour: Int { UserDefaultsManager.get(forKey: .recordResetHour) as? Int ?? 6 }
    
    var isDateChanged: Bool {
        let today = Date()
        let compareDay = dailyManager.currentDaily.day.nextDay.setTime(hour: RecordsManager.resetHour)
        return today >= compareDay
    }
    
    var isTaskTargetOn: Bool {
        return self.currentTask?.isTaskTargetTimeOn ?? false
    }
    var remainingTaskTime: Int {
        return (currentTask?.taskTargetTime ?? 0) - currentTaskSumTime
    }
    
    var currentTaskSumTime: Int {
        if let taskName = currentTask?.taskName {
            return dailyManager.currentDaily.tasks[taskName] ?? 0
        } else { return 0 }
    }
    
    private init() {
        self.recordTimes.load()
        self.taskManager.loadTasks()
        self.configureCurrentTask()
    }
    
    private func configureCurrentTask() {
        if let task = taskManager.tasks.first(where: { $0.taskName == recordTimes.recordTask }) {
            self.currentTask = task
        }
    }
    
    func modifyRecord(with newDaily: Daily) {
        // 오늘의 기록인 경우 daily도 업데이트
        if dailyManager.currentDaily.day.YYYYMMDDstyleString == newDaily.day.YYYYMMDDstyleString {
            dailyManager.updateDaily(to: newDaily)
            self.recordTimes.sync(newDaily)
        }
        self.dailyManager.modifyDaily(newDaily)
    }
}
