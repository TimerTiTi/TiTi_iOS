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
    private var timerCount: Int = 0
    
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
    
    var setttedGoalTime: Int {
        return RecordController.shared.recordTimes.settedGoalTime
    }
    
    func updateTimes() {
        self.times = RecordController.shared.recordTimes.currentTimes()
    }
    
    func updateDaily() {
        self.daily = RecordController.shared.daily
    }
    
    func updateTask() {
        self.task = RecordController.shared.recordTimes.recordTask
    }
    
    func updateModeNum() {
        UserDefaultsManager.set(to: 2, forKey: .VCNum)
        RecordController.shared.recordTimes.updateMode(to: 2)
    }
    
    func changeTask(to task: String) {
        self.task = task
        let taskTime = RecordController.shared.daily.tasks[task] ?? 0
        RecordController.shared.recordTimes.updateTask(to: task, fromTime: taskTime)
    }
    
    func timerAction() {
        if self.timerRunning {
            self.timerStart()
        } else {
            self.timerStop()
        }
    }
    
    func stopwatchReset() {
        RecordController.shared.recordTimes.resetStopwatch()
        self.times = RecordController.shared.recordTimes.currentTimes()
    }
    
    func newRecord() {
        RecordController.shared.daily.reset()
        RecordController.shared.recordTimes.reset()
        self.updateDaily()
        self.updateTimes()
    }
    
    private func timerStart() {
        // timer 동작, runningUI 반영
        self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.timerLogic), userInfo: nil, repeats: true)
        RecordController.shared.recordTimes.recordStart()
        self.timerRunning = true
        self.runningUI = true
    }
    
    @objc func timerLogic() {
        self.timerCount += 1
        self.times = RecordController.shared.recordTimes.currentTimes()
        if self.timerCount%5 == 0 {
            let current = Date()
            RecordController.shared.daily.update(at: current)
        }
    }
    
    private func timerStop() {
        self.timer.invalidate()
        self.timerRunning = false
        self.runningUI = false
        self.timerCount = 0
        let endAt = Date()
        RecordController.shared.recordTimes.recordStop(finishAt: endAt)
        RecordController.shared.daily.update(at: endAt)
        
        self.updateDaily()
        RecordController.shared.dailys.addDaily(self.daily)
    }
    
    func enterBackground() {
        print("background")
        self.timer.invalidate()
    }
    
    func enterForground() {
        print("forground")
        self.updateTimes()
        self.timerStart()
    }
}
