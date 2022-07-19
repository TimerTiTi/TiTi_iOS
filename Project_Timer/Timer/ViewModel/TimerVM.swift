//
//  TimerVM.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2022/05/04.
//  Copyright © 2022 FDEE. All rights reserved.
//

import Foundation
import Combine
import UserNotifications

final class TimerVM {
    @Published private(set) var times: Times
    @Published private(set) var daily: Daily
    @Published private(set) var task: String
    @Published private(set) var runningUI = false {
        didSet {
            self.timeOfTimerViewModel.isRunning = runningUI
        }
    }
    @Published private(set) var soundAlert = false
    @Published private(set) var warningNewDate = false
    private(set) var timerRunning = false
    private var timerCount: Int = 0
    private let userNotificationCenter = UNUserNotificationCenter.current()
    private var showAnimation: Bool = true
    
    private var timer = Timer()
    
    let timeOfTimerViewModel: TimeOfTimerViewModel
    let timeOfSumViewModel: TimeLabelViewModel
    let timeOfTargetViewModel: CountdownTimeLabelViewModel
    
    init() {
        let currentTimes = RecordController.shared.recordTimes.currentTimes()
        self.times = currentTimes
        self.daily = RecordController.shared.daily
        self.task = RecordController.shared.recordTimes.recordTask
        self.timeOfTimerViewModel = TimeOfTimerViewModel(time: currentTimes.timer)
        self.timeOfSumViewModel = TimeLabelViewModel(time: currentTimes.sum, fontSize: 32)
        self.timeOfTargetViewModel = CountdownTimeLabelViewModel(time: currentTimes.goal, fontSize: 32)
        self.requestNotificationAuthorization()
        self.soundAlert = false
        self.updateAnimationSetting()
        
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
    
    var settedTimerTime: Int {
        return RecordController.shared.recordTimes.settedTimerTime
    }
    
    var settedGoalTime: Int {
        return RecordController.shared.recordTimes.settedGoalTime
    }
    
    func updateTimes() {
        self.times = RecordController.shared.recordTimes.currentTimes()
        self.timeOfTimerViewModel.updateTime(self.times.timer, showsAnimation: self.showAnimation)
        self.timeOfSumViewModel.updateTime(self.times.sum, showsAnimation: self.showAnimation)
        self.timeOfTargetViewModel.updateTime(self.times.goal, showsAnimation: self.showAnimation)
    }
    
    func updateDaily() {
        self.daily = RecordController.shared.daily
    }
    
    func updateTask() {
        self.task = RecordController.shared.recordTimes.recordTask
    }
    
    func updateModeNum() {
        UserDefaultsManager.set(to: 1, forKey: .VCNum)
        RecordController.shared.recordTimes.updateMode(to: 1)
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
            self.updateAnimationSetting()
            RecordController.shared.recordTimes.recordStart()
            self.checkTimerReset()
            self.timerStart()
            self.setBadge()
            self.sendNotification()
        }
    }
    
    func timerReset() {
        self.updateAnimationSetting()
        RecordController.shared.recordTimes.resetTimer()
        self.updateTimes()
    }
    
    func updateTimerTime(to timer: Int) {
        RecordController.shared.recordTimes.updateTimerTime(to: timer)
        self.updateTimes()
    }
    
    func newRecord() {
        RecordController.shared.daily.reset()
        RecordController.shared.recordTimes.reset()
        self.updateDaily()
        self.updateTimes()
    }
    
    private func checkTimerReset() {
        guard self.times.timer <= 0 else { return }
        self.timerReset()
    }
    
    private func timerStart() {
        // timer 동작, runningUI 반영
        guard self.timerRunning == false else { return }
        print("timer start")
        self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.timerLogic), userInfo: nil, repeats: true)
        self.timerRunning = true
        self.runningUI = true
        self.soundAlert = false
    }
    
    @objc func timerLogic() {
        print("timer action")
        self.timerCount += 1
        self.updateTimes()
        if self.timerCount%5 == 0 {
            RecordController.shared.daily.update(at: Date())
        }
        
        if self.times.timer < 1 {
            self.timerStop()
            self.removeBadge()
            self.removeNotification()
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
        self.soundAlert = true
        let endAt = Date()
        RecordController.shared.daily.update(at: endAt)
        self.updateDaily()
        RecordController.shared.recordTimes.recordStop(finishAt: endAt, taskTime: self.daily.tasks[self.task] ?? 0)
        RecordController.shared.dailys.addDaily(self.daily)
        self.updateTimes()
    }
    
    func enterBackground() {
        print("background")
        self.timer.invalidate()
        self.timerRunning = false
    }
    
    func enterForground() {
        print("forground")
        self.timerStart()
        self.timerLogic()
    }
    
    private func sendNotification() {
        guard UserDefaultsManager.get(forKey: .timerPushable) as? Bool ?? true else { return }
        let remainTimer = self.times.timer
        let alarm_5m = remainTimer - 300
        self.postNoti(interval: Double(remainTimer), body: "Timer finished!".localized(), identifier: "Timer finished")
        if alarm_5m >= 0 {
            self.postNoti(interval: Double(alarm_5m), body: "5 minutes left".localized(), identifier: "Timer 5 min")
        }
    }
    
    private func postNoti(interval: Double, body: String, identifier: String) {
        let notificationContent = UNMutableNotificationContent()
        notificationContent.title = "Timer".localized()
        notificationContent.body = body
        notificationContent.sound = UNNotificationSound.default
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: interval, repeats: false)
        let request = UNNotificationRequest(identifier: identifier, content: notificationContent, trigger: trigger)
        self.userNotificationCenter.add(request) { error in
            if let error = error {
                print("Notification Error: \(error)")
            }
        }
    }
    
    func postRecordingStartNoti() {
        self.postNoti(interval: 0.3,
                      body: "Recording started".localized(),
                      identifier: "Timer Recording Start")
    }
    
    private func removeNotification() {
        self.userNotificationCenter.removeAllPendingNotificationRequests()
    }
    
    private func updateAnimationSetting() {
        self.showAnimation = UserDefaultsManager.get(forKey: .timelabelsAnimation) as? Bool ?? true
    }
}
