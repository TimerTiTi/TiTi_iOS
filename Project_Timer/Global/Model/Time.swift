//
//  Time.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2021/02/28.
//  Copyright © 2021 FDEE. All rights reserved.
//

import Foundation

struct Time {
    var startTime: Date // 시간측정 기준값
    var startGoalTime: Int
    var startSumTime: Int
    var startTimerTime: Int // Timer 모드 설정값
    var startStopwatchTime: Int // Stopwatch 모드 설정값
    
    init(goal: Int, sum: Int, stopwatch: Int) { // Stopwatch 용 init
        self.startTime = Date()
        self.startGoalTime = goal
        self.startSumTime = sum
        self.startStopwatchTime = stopwatch
        self.startTimerTime = 0
    }
    
    init(goal: Int, sum: Int, timer: Int) { // Timer 용 init
        self.startTime = Date()
        self.startGoalTime = goal
        self.startSumTime = sum
        self.startTimerTime = timer
        self.startStopwatchTime = 0
    }
    
    mutating func resetStopwatchTime() {
        self.startStopwatchTime = 0
    }
}

extension Time {
    static func seconds(from: Date, to: Date) -> Int {
        let timeComponents = Calendar.current.dateComponents([.hour, .minute, .second], from: from, to: to)
        return (timeComponents.hour ?? 0)*3600 + (timeComponents.minute ?? 0)*60 + (timeComponents.second ?? 0)
    }
}
