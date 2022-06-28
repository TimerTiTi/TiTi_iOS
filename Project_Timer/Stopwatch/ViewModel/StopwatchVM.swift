//
//  StopwatchVM.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2022/04/29.
//  Copyright © 2022 FDEE. All rights reserved.
//

import Foundation
import Combine
import UserNotifications

final class StopwatchVM {
    @Published private(set) var times: Times {
        didSet {
            self.timeOfStopwatchViewModel.updateTime(times.stopwatch)
            self.timeOfSumViewModel.updateTime(times.sum)
            self.timeOfTargetViewModel.updateTime(times.goal)
        }
    }
    @Published private(set) var daily: Daily
    @Published private(set) var task: String
    @Published private(set) var runningUI = false
    @Published private(set) var warningNewDate = false
    private(set) var timerRunning = false {
        didSet {
            self.timeOfStopwatchViewModel.isRunning = timerRunning
        }
    }
    private var timerCount: Int = 0
    private let userNotificationCenter = UNUserNotificationCenter.current()
    
    private var timer = Timer()
    
    var timeOfStopwatchViewModel: TimeOfStopwatchViewModel
    var timeOfSumViewModel: TimeLabelViewModel
    var timeOfTargetViewModel: TimeLabelViewModel
    
    init() {
        let currentTimes = RecordController.shared.recordTimes.currentTimes()
        self.times = currentTimes
        self.daily = RecordController.shared.daily
        self.task = RecordController.shared.recordTimes.recordTask
        self.timeOfStopwatchViewModel = TimeOfStopwatchViewModel(time: currentTimes.stopwatch, showAnimation: true)
        self.timeOfSumViewModel = TimeLabelViewModel(time: currentTimes.sum,
                                                     updateType: .countUp,
                                                     showAnimation: true)
        self.timeOfTargetViewModel = TimeLabelViewModel(time: currentTimes.goal,
                                                        updateType: .countDown,
                                                        showAnimation: true)
        self.requestNotificationAuthorization()
        
        if RecordController.shared.recordTimes.recording {
            print("automatic start")
            self.timerStart()
        } else {
            self.checkRecordDate()
        }
    }
    
    private func requestNotificationAuthorization() {
        let authOptions = UNAuthorizationOptions(arrayLiteral: .alert, .badge, .sound)
        
        self.userNotificationCenter.requestAuthorization(options: authOptions) { success, error in
            if let error = error {
                print("Error: \(error)")
            }
        }
    }
    
    private func checkRecordDate() {
        self.warningNewDate = RecordController.shared.showWarningOfRecordDate
    }
    
    var settedGoalTime: Int {
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
        self.updateTimes()
    }
    
    func timerAction() {
        if self.timerRunning {
            self.timerStop()
            self.removeBadge()
            self.removeNotification()
        } else {
            RecordController.shared.recordTimes.recordStart()
            self.timerStart()
            self.setBadge()
            self.sendNotification()
        }
    }
    
    func stopwatchReset() {
        RecordController.shared.recordTimes.resetStopwatch()
        self.updateTimes()
    }
    
    func newRecord() {
        RecordController.shared.daily.reset()
        RecordController.shared.recordTimes.reset()
        self.updateDaily()
        self.updateTimes()
    }
    
    private func timerStart() {
        // timer 동작, runningUI 반영
        guard self.timerRunning == false else { return }
        print("timer start")
        self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.timerLogic), userInfo: nil, repeats: true)
        self.timerRunning = true
        self.runningUI = true
    }
    
    @objc func timerLogic() {
        print("timer action")
        self.timerCount += 1
        self.updateTimes()
        if self.timerCount%5 == 0 {
            RecordController.shared.daily.update(at: Date())
        }
    }
    
    private func setBadge() {
        NotificationCenter.default.post(name: .setBadge, object: nil)
    }
    
    private func removeBadge() {
        NotificationCenter.default.post(name: .removeBadge, object: nil)
    }
    
    private func timerStop() {
        print("timer stop")
        self.timer.invalidate()
        self.timerRunning = false
        self.runningUI = false
        self.timerCount = 0
        let endAt = Date()
        RecordController.shared.daily.update(at: endAt)
        self.updateDaily()
        RecordController.shared.recordTimes.recordStop(finishAt: endAt, taskTime: self.daily.tasks[self.task] ?? 0)
        RecordController.shared.dailys.addDaily(self.daily)
    }
    
    func enterBackground() {
        print("background")
        self.timer.invalidate()
        self.timerRunning = false
    }
    
    func enterForground() {
        print("forground")
        self.updateTimes()
        self.timerStart()
    }
    
    private func sendNotification() {
        guard UserDefaultsManager.get(forKey: .stopwatchPushable) as? Bool ?? true else { return }
        for i in 1...24 {
            let notificationContent = UNMutableNotificationContent()
            notificationContent.title = "Stopwatch".localized()
            notificationContent.body = " \(i)" + "hours passed.".localized()
            notificationContent.sound = UNNotificationSound.default
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: Double(i*3600), repeats: false)
            let request = UNNotificationRequest(identifier: "noti\(i)", content: notificationContent, trigger: trigger)
            self.userNotificationCenter.add(request) { error in
                if let error = error {
                    print("Notification Error: \(error)")
                }
            }
        }
    }
    
    private func removeNotification() {
        self.userNotificationCenter.removeAllPendingNotificationRequests()
    }
}
