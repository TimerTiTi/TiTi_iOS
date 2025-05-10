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
    private(set) var timerRunning = false
    private let userNotificationCenter = UNUserNotificationCenter.current()
    private var showAnimation: Bool = true
    var darkerMode: Bool = false {
        didSet { self.updateTimes() }
    }
    
    private var timer = Timer()
    
    let timeOfSumViewModel: NormalTimeLabelVM
    let timeOfTimerViewModel: TimerTimeLabelVM
    let timeOfTargetViewModel: CountdownTimeLabelVM
    
    init() {
        let currentTimes = RecordsManager.shared.recordTimes.currentTimes()
        let isWhite = UserDefaultsManager.get(forKey: .timerTextIsWhite) as? Bool ?? true
        self.times = currentTimes
        self.daily = RecordsManager.shared.currentDaily
        self.taskName = RecordsManager.shared.recordTimes.recordTask
        self.timeOfSumViewModel = NormalTimeLabelVM(time: currentTimes.sum, fontSize: 32, isWhite: isWhite)
        self.timeOfTimerViewModel = TimerTimeLabelVM(time: currentTimes.timer, fontSize: 70, isWhite: isWhite)
        self.timeOfTargetViewModel = CountdownTimeLabelVM(time: currentTimes.goal, fontSize: 32, isWhite: isWhite)
        self.requestNotificationAuthorization()
        self.soundAlert = false
        self.updateAnimationSetting()
        
        if RecordsManager.shared.recordTimes.recording {
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
        if RecordsManager.shared.isDateChanged {
            self.createNewRecord()
        }
    }
    
    var settedTimerTime: Int {
        return RecordsManager.shared.recordTimes.settedTimerTime
    }
    
    var settedGoalTime: Int {
        return RecordsManager.shared.recordTimes.settedGoalTime
    }
    
    func updateTimes() {
        self.times = RecordsManager.shared.recordTimes.currentTimes(darkerMode: self.darkerMode)
        self.timeOfSumViewModel.updateTime(self.times.sum, showsAnimation: self.showAnimation)
        let timer = self.darkerMode ? self.times.timerForDarker : self.times.timer
        self.timeOfTimerViewModel.updateTime(timer, showsAnimation: self.showAnimation)
        
        if RecordsManager.shared.isTaskTargetOn {
            self.timeOfTargetViewModel.updateTime(self.times.remainingTaskTime, showsAnimation: self.showAnimation)
        } else {
            self.timeOfTargetViewModel.updateTime(self.times.goal, showsAnimation: self.showAnimation)
        }
    }
    
    func updateDaily() {
        self.daily = RecordsManager.shared.currentDaily
    }
    
    func updateTask() {
        self.taskName = RecordsManager.shared.recordTimes.recordTask
        self.updateTimes()
    }
    
    func updateModeNum() {
        UserDefaultsManager.set(to: 1, forKey: .VCNum)
        RecordsManager.shared.recordTimes.updateMode(to: 1)
    }
    
    func changeTask(to taskName: String) {
        let currentTaskSumTime = RecordsManager.shared.currentDaily.tasks[taskName] ?? 0
        self.taskName = taskName
        RecordsManager.shared.recordTimes.updateTask(to: taskName, fromTime: currentTaskSumTime)
        self.updateTimes()
    }
    
    func timerAction() {
        if self.timerRunning {
            self.terminateTimer()
            self.checkRecordDate()
        } else {
            self.checkRecordDate()
            self.updateAnimationSetting()
            RecordsManager.shared.recordTimes.recordStart()
            self.checkTimerReset()
            self.timerStart()
            self.setBadge()
            self.sendNotification()
            self.startLiveActivity()
        }
    }
    
    func timerReset() {
        self.updateAnimationSetting()
        RecordsManager.shared.recordTimes.resetTimer()
        self.updateTimes()
    }
    
    func updateTimerTime(to timer: Int) {
        RecordsManager.shared.recordTimes.updateTimerTime(to: timer)
        self.updateTimes()
    }
    
    func createNewRecord() {
        RecordsManager.shared.currentDaily.reset()
        RecordsManager.shared.recordTimes.reset()
        self.updateDaily()
        self.updateTimes()
        ToastManager.shared.show(toast: .newRecord(
            date: RecordsManager.shared.currentDaily.day.YYYYMMDDstyleString)
        )
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
        RecordsManager.shared.currentDaily.update(at: endAt)
        self.updateDaily()
        RecordsManager.shared.recordTimes.recordStop(finishAt: endAt, taskTime: self.daily.tasks[self.taskName] ?? 0)
        RecordsManager.shared.dailyManager.addDaily(self.daily)
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
        self.postNoti(interval: Double(remainTimer), body: Localized.string(.System_Noti_TimerFinished), identifier: "Timer finished")
        
        guard UserDefaultsManager.get(forKey: .timer5minPushable) as? Bool ?? true else { return }
        let alarm_5m = remainTimer - 300
        if alarm_5m > 0 {
            self.postNoti(interval: Double(alarm_5m), body: Localized.string(.System_Noti_Timer5Left), identifier: "Timer 5 min")
        }
    }
    
    private func postNoti(interval: Double, body: String, identifier: String) {
        let notificationContent = UNMutableNotificationContent()
        notificationContent.title = Localized.string(.Common_Text_Timer)
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
                      body: Localized.string(.System_Noti_RecordingStart),
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
                let initialContentState = TimerStopwatchAttributes.ContentState(taskName: self.taskName, timer: date)
                let activityAttributes = TimerStopwatchAttributes(isTimer: true)
                let activityContent = ActivityContent(state: initialContentState, staleDate: Calendar.current.date(byAdding: .minute, value: 30, to: Date())!)
                
                do {
                    let activity = try Activity.request(attributes: activityAttributes, content: activityContent)
                    print("Requested Lockscreen Live Activity(Timer) \(String(describing: activity.id)).")
                } catch (let error) {
                    print("Error requesting Lockscreen Live Activity(Timer) \(error.localizedDescription).")
                }
            }
        }
    }
    
    private func endLiveActivity() async {
        if #available(iOS 16.2, *) {
            let finalStatus = TimerStopwatchAttributes.titiStatus(taskName: self.taskName, timer: Date.now...Date.now)
            let finalContent = ActivityContent(state: finalStatus, staleDate: nil)

            for activity in Activity<TimerStopwatchAttributes>.activities {
                await activity.end(finalContent, dismissalPolicy: .immediate)
                print("Ending the Live Activity(Timer): \(activity.id)")
            }
        }
    }
}
