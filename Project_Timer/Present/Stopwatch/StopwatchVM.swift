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
import ActivityKit

final class StopwatchVM {
    @Published private(set) var times: Times
    @Published private(set) var daily: Daily
    @Published private(set) var taskName: String
    @Published private(set) var runningUI = false {
        didSet {
            self.timeOfSumViewModel.updateRunning(to: runningUI)
            self.timeOfStopwatchViewModel.updateRunning(to: runningUI)
            self.timeOfTargetViewModel.updateRunning(to: runningUI)
        }
    }
    
    private(set) var timerRunning = false
    private let userNotificationCenter = UNUserNotificationCenter.current()
    private var showAnimation: Bool = true
    var darkerMode: Bool = false {
        didSet { self.updateTimes() }
    }
    
    private var timer = Timer()
    
    let timeOfSumViewModel: NormalTimeLabelVM
    let timeOfStopwatchViewModel: StopwatchTimeLabelVM
    let timeOfTargetViewModel: CountdownTimeLabelVM
    
    init() {
        let currentTimes = RecordsManager.shared.recordTimes.currentTimes()
        let isWhite = UserDefaultsManager.get(forKey: .stopwatchTextIsWhite) as? Bool ?? true
        self.times = currentTimes
        self.daily = RecordsManager.shared.currentDaily
        self.taskName = RecordsManager.shared.recordTimes.recordTask
        self.timeOfSumViewModel = NormalTimeLabelVM(time: currentTimes.sum, fontSize: 32, isWhite: isWhite)
        self.timeOfStopwatchViewModel = StopwatchTimeLabelVM(time: currentTimes.stopwatch, fontSize: 70, isWhite: isWhite)
        self.timeOfTargetViewModel = CountdownTimeLabelVM(time: currentTimes.goal, fontSize: 32, isWhite: isWhite)
        self.requestNotificationAuthorization()
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
            self.newRecord()
        }
    }
    
    var settedGoalTime: Int {
        return RecordsManager.shared.recordTimes.settedGoalTime
    }
    
    func updateTimes() {
        self.times = RecordsManager.shared.recordTimes.currentTimes(darkerMode: self.darkerMode)
        self.timeOfStopwatchViewModel.updateTime(self.times.stopwatch, showsAnimation: self.showAnimation)
        self.timeOfSumViewModel.updateTime(self.times.sum, showsAnimation: self.showAnimation)
        
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
        UserDefaultsManager.set(to: 2, forKey: .VCNum)
        RecordsManager.shared.recordTimes.updateMode(to: 2)
    }
    
    func changeTask(to taskName: String) {
        let currentTaskSumTime = RecordsManager.shared.currentDaily.tasks[taskName] ?? 0
        self.taskName = taskName
        RecordsManager.shared.recordTimes.updateTask(to: taskName, fromTime: currentTaskSumTime)
        self.updateTimes()
    }
    
    func timerAction() {
        if self.timerRunning {
            self.timerStop()
            self.removeBadge()
            self.removeNotification()
            async {
                await self.endLiveActivity()
            }
            self.checkRecordDate()
        } else {
            self.checkRecordDate()
            self.updateAnimationSetting()
            RecordsManager.shared.recordTimes.recordStart()
            self.timerStart()
            self.setBadge()
            self.sendNotification()
            self.startLiveActivity()
        }
    }
    
    func stopwatchReset() {
        self.updateAnimationSetting()
        RecordsManager.shared.recordTimes.resetStopwatch()
        self.updateTimes()
    }
    
    func newRecord() {
        RecordsManager.shared.currentDaily.reset()
        RecordsManager.shared.recordTimes.reset()
        self.updateDaily()
        self.updateTimes()
        ToastMessage.shared.show(type: .newRecord)
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
        }
    }
    
    @objc func timerLogic() {
        self.updateTimes()
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
        self.updateTimes()
        self.timerStart()
    }
    
    private func sendNotification() {
        guard UserDefaultsManager.get(forKey: .stopwatchPushable) as? Bool ?? true else { return }
        for i in 1...24 {
            self.postNoti(interval: Double(i*3600),
                          body: Localized.string(.System_Noti_StopwatchHourPassed, op: "\(i)"),
                          identifier: "noti\(i)")
        }
    }
    
    private func postNoti(interval: Double, body: String, identifier: String) {
        let notificationContent = UNMutableNotificationContent()
        notificationContent.title = Localized.string(.Common_Text_Stopwatch)
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
                      identifier: "Stopwatch Recording Start")
    }
    
    private func removeNotification() {
        self.userNotificationCenter.removeAllPendingNotificationRequests()
    }
    
    private func updateAnimationSetting() {
        self.showAnimation = UserDefaultsManager.get(forKey: .timelabelsAnimation) as? Bool ?? true
    }
    
    func updateTextColor(isWhite: Bool) {
        self.timeOfSumViewModel.updateIsWhite(to: isWhite)
        self.timeOfStopwatchViewModel.updateIsWhite(to: isWhite)
        self.timeOfTargetViewModel.updateIsWhite(to: isWhite)
    }
}

// MARK: Live Activity & Dynamic Island
extension StopwatchVM {
    private func startLiveActivity() {
        if #available(iOS 16.2, *) {
            if ActivityAuthorizationInfo().areActivitiesEnabled {
                let past = Calendar.current.date(byAdding: .second, value: -self.times.stopwatch, to: Date())!
                let future = Calendar.current.date(byAdding: .hour, value: 8, to: Date())!
                let initialContentState = TimerStopwatchAttributes.ContentState(taskName: self.taskName, timer: past...future)
                let activityAttributes = TimerStopwatchAttributes(isTimer: false)
                let activityContent = ActivityContent(state: initialContentState, staleDate: Calendar.current.date(byAdding: .minute, value: 30, to: Date())!)
                
                do {
                    let activity = try Activity.request(attributes: activityAttributes, content: activityContent)
                    print("Requested Lockscreen Live Activity(Stopwatch) \(String(describing: activity.id)).")
                } catch (let error) {
                    print("Error requesting Lockscreen Live Activity(Stopwatch) \(error.localizedDescription).")
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
                print("Ending the Live Activity(Stopwatch): \(activity.id)")
            }
        }
    }
}
