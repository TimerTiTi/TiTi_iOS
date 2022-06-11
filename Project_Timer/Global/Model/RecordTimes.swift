//
//  Time.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2021/02/28.
//  Copyright © 2021 FDEE. All rights reserved.
//

import Foundation

struct RecordTimes: Codable, CustomStringConvertible {
    var description: String {
        return "\(self.currentTimes()), \(self.recordTaskFromTime))"
    }
    static let fileName: String = "recordTimes.json"
    
    private(set) var recordTask: String = "none" // 측정중인 과목명
    private(set) var recordTaskFromTime: Int = 0 // 측정중인 과목 기준시간값
    
    private(set) var recordStartAt: Date = Date() // 기록측정 시작시각
    private(set) var recording: Bool = false // 기록중인지 여부값, network 상 다른 기기에서도 표시 가능
    
    private(set) var settedGoalTime: Int = 21600// 사용자가 설정한 목표시간값
    private(set) var settedTimerTime: Int = 2400 // 사용자가 설정한 타이머 시간값
    
    private var recordingMode: Int = 1 // 기록모드값, 1: timer, 2: stopwatch
    private var savedSumTime: Int = 0 // sum 기준값 및 저장된 sum 값
    private var savedTimerTime: Int = 2400 // timer 기준값 및 저장된 timer 값
    private var savedStopwatchTime: Int  = 0// stopwath 기준값 및 저장된 stopwatch 값
    private var savedGoalTime: Int = 21600 // 저장된 goalTime 값
    
    private(set) var recordStartTimeline = Array(repeating: 0, count: 24) // 기록시작시 timeline 값
    
    // task 를 변경할 경우 반영 (기록하기 전 반영)
    mutating func updateTask(to taskName: String, fromTime: Int) {
        print("fromTime: \(fromTime)")
        self.recordTask = taskName
        self.recordTaskFromTime = fromTime
        self.savedStopwatchTime = fromTime
        self.save()
    }
    // mode 를 변경할 경우 반영 (기록하기 전 반영)
    mutating func updateMode(to mode: Int) {
        self.recordingMode = mode
        self.save()
    }
    // 기록 시작시 설정
    mutating func recordStart() {
        self.recordStartAt = Date()
        self.recording = true
        self.recordStartTimeline = RecordController.shared.daily.timeline
        self.save()
    }
    // 기록 종료시 설정
    mutating func recordStop(finishAt: Date, taskTime: Int) {
        self.recording = false
        self.recordTaskFromTime = taskTime
        self.savedSumTime += self.interval(to: finishAt)
        self.savedGoalTime = self.settedGoalTime - self.savedSumTime
        switch self.recordingMode {
        case 1: self.savedTimerTime -= self.interval(to: finishAt)
        case 2: self.savedStopwatchTime += self.interval(to: finishAt)
        default: break
        }
        self.save()
    }
    // 사용자가 timer 시간을 변경시 반영 (기록하기 전 반영)
    mutating func updateTimerTime(to timerTime: Int) {
        self.settedTimerTime = timerTime
        self.resetTimer()
    }
    // 사용자가 goal 시간을 변경시 반영 (기록하기 전 반영)
    mutating func updateGoalTime(to goalTime: Int) {
        self.settedGoalTime = goalTime
        self.save()
    }
    // stopwatch 시간 초기화 (기록하기 전 반영)
    mutating func resetStopwatch() {
        self.savedStopwatchTime = 0
        self.save()
    }
    // timer 재시작시 시간 초기화 (기록시 수행)
    mutating func resetTimer() {
        self.savedTimerTime = self.settedTimerTime
        self.save()
    }
    // 앱 시작시 load 및 초기화 작업
    mutating func load() {
        guard let savedRecordTimes = Storage.retrive(RecordTimes.fileName, from: .documents, as: RecordTimes.self) else {
            self = RecordTimes()
            self.recordTask = UserDefaults.standard.value(forKey: "task") as? String ?? "none"
            self.settedGoalTime = UserDefaults.standard.value(forKey: "allTime") as? Int ?? 21600
            self.settedTimerTime = UserDefaults.standard.value(forKey: "second") as? Int ?? 2400
            self.savedSumTime = UserDefaults.standard.value(forKey: "sum2") as? Int ?? 0
            self.savedTimerTime = UserDefaults.standard.value(forKey: "second2") as? Int ?? 2400
            self.savedStopwatchTime = UserDefaults.standard.value(forKey: "sumTime_temp") as? Int ?? 0
            self.savedGoalTime = UserDefaults.standard.value(forKey: "allTime2") as? Int ?? 21600
            return
        }
        
        self = savedRecordTimes
    }
    
    func save() {
        Storage.store(self, to: .documents, as: RecordTimes.fileName)
        print("recordTimes: \(self)")
        // MARK: network 상에 반영한다면?
    }
    // 새로운 날짜의 기록 시작시 reset
    mutating func reset() {
        self.recordTaskFromTime = 0
        self.recording = false
        self.savedSumTime = 0
        self.savedTimerTime = self.settedTimerTime
        self.savedStopwatchTime = 0
        self.savedGoalTime = self.settedGoalTime
        self.save()
    }
    
    func interval(to: Date) -> Int {
        return Self.interval(from: self.recordStartAt, to: to)
    }
    
    func currentTimes(noSeconds: Bool = false) -> Times { // VC 에서 매초
        guard self.recording else {
            return Times(sum: self.savedSumTime, timer: self.savedTimerTime, stopwatch: self.savedStopwatchTime, goal: self.savedGoalTime)
        }
        
        let currentAt = Date()
        let interval = self.interval(to: currentAt)
        var currentSum = self.savedSumTime + interval
        var currentGoal = self.settedGoalTime - currentSum
        var currentTimer = self.savedTimerTime - interval
        var currentStopwatch = self.savedStopwatchTime + interval
        // noSeconds 옵션인 경우 %60 제거
        if noSeconds {
            currentSum -= currentSum%60
            currentGoal += currentGoal%60 == 0 ? 0 : (60 - currentGoal%60)
            currentTimer += currentTimer%60 == 0 ? 0 : (60 - currentTimer%60)
            currentStopwatch -= currentStopwatch%60
        }
        return Times(sum: currentSum, timer: currentTimer, stopwatch: currentStopwatch, goal: currentGoal)
    }
}

extension RecordTimes {
    static func interval(from: Date, to: Date) -> Int {
        let timeComponents = Calendar.current.dateComponents([.hour, .minute, .second], from: from, to: to)
        return (timeComponents.hour ?? 0)*3600 + (timeComponents.minute ?? 0)*60 + (timeComponents.second ?? 0)
    }
}
