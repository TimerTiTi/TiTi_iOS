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
import ActivityKit

final class TimerVM {
    @Published private(set) var times: Times
    @Published private(set) var daily: Daily
    @Published private(set) var taskName: String
    @Published private(set) var runningUI = false {
        didSet {
            self.timeOfSumViewModel.updateRunning(to: runningUI)
            self.timeOfTimerViewModel.updateRunning(to: runningUI)
            self.timeOfTargetViewModel.updateRunning(to: runningUI)
        }
    }
    @Published private(set) var soundAlert = false
    @Published private(set) var warningNewDate = false
    private(set) var timerRunning = false
    private let userNotificationCenter = UNUserNotificationCenter.current()
    private var showAnimation: Bool = true
    var darkerMode: Bool = false {
        didSet { self.updateTimes() }
    }
    
    private var timer = Timer()
    
    let timeOfSumViewModel: NormalTimeLabelVM
    let timeOfTimerViewModel: TimerTimeLabelVM
    let timeOfTargetViewModel: CountdownTimeLabelViewModel
    
    init() {
        let currentTimes = RecordController.shared.recordTimes.currentTimes()
        let isWhite = UserDefaultsManager.get(forKey: .timerTextIsWhite) as? Bool ?? true
        self.times = currentTimes
        self.daily = RecordController.shared.daily
        self.taskName = RecordController.shared.recordTimes.recordTask
        self.timeOfSumViewModel = NormalTimeLabelVM(time: currentTimes.sum, fontSize: 32, isWhite: isWhite)
        self.timeOfTimerViewModel = TimerTimeLabelVM(time: currentTimes.timer, fontSize: 70, isWhite: isWhite)
        self.timeOfTargetViewModel = CountdownTimeLabelViewModel(time: currentTimes.goal, fontSize: 32, isWhite: isWhite)
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
        self.times = RecordController.shared.recordTimes.currentTimes(darkerMode: self.darkerMode)
        self.timeOfSumViewModel.updateTime(self.times.sum, showsAnimation: self.showAnimation)
        let timer = self.darkerMode ? self.times.timerForDarker : self.times.timer
        self.timeOfTimerViewModel.updateTime(timer, showsAnimation: self.showAnimation)
        
        if RecordController.shared.isTaskGargetOn {
            self.timeOfTargetViewModel.updateTime(self.times.remainingTaskTime, showsAnimation: self.showAnimation)
        } else {
            self.timeOfTargetViewModel.updateTime(self.times.goal, showsAnimation: self.showAnimation)
        }
    }
    
    func updateDaily() {
        self.daily = RecordController.shared.daily
    }
    
    func updateTask() {
        self.taskName = RecordController.shared.recordTimes.recordTask
        self.updateTimes()
    }
    
    func updateModeNum() {
        UserDefaultsManager.set(to: 1, forKey: .VCNum)
        RecordController.shared.recordTimes.updateMode(to: 1)
    }
    
    func changeTask(to taskName: String) {
        let currentTaskSumTime = RecordController.shared.daily.tasks[taskName] ?? 0
        self.taskName = taskName
        RecordController.shared.recordTimes.updateTask(to: taskName, fromTime: currentTaskSumTime)
        self.updateTimes()
    }
    
    func timerAction() {
        if self.timerRunning {
            self.terminateTimer()
        } else {
            self.updateAnimationSetting()
            RecordController.shared.recordTimes.recordStart()
            self.checkTimerReset()
            self.timerStart()
            self.setBadge()
            self.sendNotification()
            self.startLiveActivity()
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
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.timerLogic), userInfo: nil, repeats: true)
            self.timerRunning = true
            self.runningUI = true
            self.updateTimes()
            self.soundAlert = false
        }
    }
    
    @objc func timerLogic() {
        self.updateTimes()
        
        if self.times.timer < 1 {
            self.terminateTimer()
        }
    }
    
    private func terminateTimer() {
        self.timerStop()
        self.removeBadge()
        self.removeNotification()
        async {
            await self.endLiveActivity()
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
        self.soundAlert = true
        let endAt = Date()
        RecordController.shared.daily.update(at: endAt)
        self.updateDaily()
        RecordController.shared.recordTimes.recordStop(finishAt: endAt, taskTime: self.daily.tasks[self.taskName] ?? 0)
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
        self.timerLogic()
        // 시간이 남은 경우 timer 실행
        if self.times.timer > 0 {
            self.timerStart()
        }
    }
    
    private func sendNotification() {
        guard UserDefaultsManager.get(forKey: .timerPushable) as? Bool ?? true else { return }
        let remainTimer = self.times.timer
        self.postNoti(interval: Double(remainTimer), body: "Timer finished!".localized(), identifier: "Timer finished")
        
        guard UserDefaultsManager.get(forKey: .timer5minPushable) as? Bool ?? true else { return }
        let alarm_5m = remainTimer - 300
        if alarm_5m > 0 {
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
    
    func sendRecordingStartNotification() {
        self.postNoti(interval: 0.1,
                      body: "Recording started".localized(),
                      identifier: "Timer Recording Start")
    }
    
    private func removeNotification() {
        self.userNotificationCenter.removeAllPendingNotificationRequests()
    }
    
    private func updateAnimationSetting() {
        self.showAnimation = UserDefaultsManager.get(forKey: .timelabelsAnimation) as? Bool ?? true
    }
    
    func updateTextColor(isWhite: Bool) {
        self.timeOfSumViewModel.updateIsWhite(to: isWhite)
        self.timeOfTimerViewModel.updateIsWhite(to: isWhite)
        self.timeOfTargetViewModel.updateIsWhite(to: isWhite)
    }
}

// MARK: Live Activity & Dynamic Island
extension TimerVM {
    private func startLiveActivity() {
        if #available(iOS 16.2, *) {
            if ActivityAuthorizationInfo().areActivitiesEnabled {
                let future = Calendar.current.date(byAdding: .second, value: self.times.timer, to: Date())!
                let date = Date.now...future
                let initialContentState = TiTiLockscreenAttributes.ContentState(taskName: self.taskName, timer: date)
                let activityAttributes = TiTiLockscreenAttributes(isTimer: true)
                let activityContent = ActivityContent(state: initialContentState, staleDate: Calendar.current.date(byAdding: .minute, value: 30, to: Date())!)
                
                do {
                    TiTiActivity.shared.activity = try Activity.request(attributes: activityAttributes, content: activityContent)
                    print("Requested Lockscreen Live Activity(Timer) \(String(describing: TiTiActivity.shared.activity?.id)).")
                } catch (let error) {
                    print("Error requesting Lockscreen Live Activity(Timer) \(error.localizedDescription).")
                }
            }
        }
    }
    
    private func endLiveActivity() async {
        if #available(iOS 16.2, *) {
            let finalStatus = TiTiLockscreenAttributes.titiStatus(taskName: self.taskName, timer: Date.now...Date.now)
            let finalContent = ActivityContent(state: finalStatus, staleDate: nil)

            for activity in Activity<TiTiLockscreenAttributes>.activities {
                await TiTiActivity.shared.activity?.end(finalContent, dismissalPolicy: .immediate)
                print("Ending the Live Activity(Timer): \(activity.id)")
            }
        }
    }
}
