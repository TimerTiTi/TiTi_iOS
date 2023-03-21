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
    var recordTimes = RecordTimes()
    var daily = Daily()
    var dailyManager = DailyManager()
    var tasks: [Task] = []
    var currentTask: Task?
    var showWarningOfRecordDate: Bool = false
    
    var currentTaskSumTime: Int {
        if let taskName = currentTask?.taskName {
            return daily.tasks[taskName] ?? 0
        } else { return 0 }
    }
    var isTaskTargetOn: Bool {
        return self.currentTask?.isTaskTargetTimeOn ?? false
    }
    var remainingTaskTime: Int {
        return (currentTask?.taskTargetTime ?? 0) - currentTaskSumTime
    }
    
    private init() {
        self.recordTimes.load()
        self.loadTasks()
        self.daily.load()
        self.dailyManager.loadDailys()
        self.configureWarningOfRecordDate()
        NotificationCenter.default.addObserver(forName: .removeNewRecordWarning, object: nil, queue: .current) { [weak self] _ in
            self?.showWarningOfRecordDate = false
        }
    }
    
    private func configureWarningOfRecordDate() {
        let today = Date().YYYYMMDDstyleString
        if today != self.daily.day.YYYYMMDDstyleString {
            self.showWarningOfRecordDate = true
        }
    }
    
    private func loadTasks() {
        self.tasks = Storage.retrive(Task.fileName, from: .documents, as: [Task].self) ?? []
        if self.tasks.isEmpty {
            self.loadFromUserDefaults()
        }
        if let task = tasks.first(where: { $0.taskName == recordTimes.recordTask }) {
            self.currentTask = task
        }
    }
    
    private func loadFromUserDefaults() {
        let taskNames = UserDefaults.standard.value(forKey: "tasks") as? [String] ?? []
        guard taskNames.isEmpty == false else { return }
        self.tasks = taskNames.map { Task($0) }
    }
    
    func modifyRecord(with newDaily: Daily) {
        // 오늘의 기록인 경우 daily도 업데이트
        if daily.day.YYYYMMDDstyleString == newDaily.day.YYYYMMDDstyleString {
            self.daily = newDaily
            self.daily.save()
            self.recordTimes.sync(newDaily)
        }
        self.dailyManager.modifyDaily(newDaily)
    }
}
