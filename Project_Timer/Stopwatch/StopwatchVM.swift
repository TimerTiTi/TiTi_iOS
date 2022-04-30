//
//  StopwatchVM.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2022/04/29.
//  Copyright © 2022 FDEE. All rights reserved.
//

import Foundation
import Combine

final class StopwatchVM {
    @Published private(set) var times: Times
    @Published private(set) var daily: Daily
    @Published private(set) var task: String
    @Published private(set) var runningUI = false
    private(set) var timerRunning = false
    
    private var timer = Timer()
    
    init() {
        self.times = RecordController.shared.recordTimes.currentTimes()
        self.daily = RecordController.shared.daily
        self.task = RecordController.shared.recordTimes.recordTask
        self.timerRunning = RecordController.shared.recordTimes.recording
        self.runningUI = self.timerRunning
        
        if self.timerRunning {
            self.timerStart()
        }
    }
    
    func timerAction() {
        if self.timerRunning {
            self.timerStart()
        } else {
            self.timerStop()
        }
    }
    
    func updateTimes() {
        self.times = RecordController.shared.recordTimes.currentTimes()
    }
    
    func updateDaily() {
        self.daily = RecordController.shared.daily
    }
    
    func updateTask(to task: String) {
        self.task = task
        let taskTime = RecordController.shared.daily.tasks[task] ?? 0
        RecordController.shared.recordTimes.updateTask(to: task, fromTime: taskTime)
    }
    
    func updateTask() {
        self.task = RecordController.shared.recordTimes.recordTask
    }
    
    func updateModeNum() {
        UserDefaultsManager.set(to: 2, forKey: .VCNum)
        RecordController.shared.recordTimes.updateMode(to: 2)
    }
    
    private func timerStart() {
        // timer 동작, runningUI 반영
        self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.timerLogic), userInfo: nil, repeats: true)
        RecordController.shared.recordTimes.recordStart()
        self.timerRunning = true
        self.runningUI = true
    }
    
    @objc func timerLogic() {
//        let seconds = RecordTimes.seconds(from: self.time.startDate, to: Date()) // 기록 시작점 ~ 현재까지 지난 초
//        self.updateTimes(interval: seconds)
//        self.daily.updateCurrentTaskTime(interval: seconds)
//        self.daily.updateMaxTime(with: seconds)
//
//        updateTIMELabels()
//        updateProgress()
//        printLogs()
//        saveTimes()
    }
    
    private func timerStop() {
        
    }
    
    func stopwatchReset() {
//        self.currentStopwatchTime = 0
//        UserDefaultsManager.set(to: 0, forKey: .sumTime_temp)
//        self.updateTIMELabels()
//        self.updateProgress()
    }
}
