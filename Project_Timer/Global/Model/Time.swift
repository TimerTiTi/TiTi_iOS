//
//  Time.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2021/02/28.
//  Copyright © 2021 FDEE. All rights reserved.
//

import Foundation

struct Time {
    var startDate: Date // 시간측정 기준값
    var fromGoalTime: Int
    var fromSumTime: Int
    var fromTimerTime: Int // Timer 모드 설정값
    var fromStopwatchTime: Int // Stopwatch 모드 설정값
    
    init(goal: Int, sum: Int, stopwatch: Int) { // Stopwatch 용 init
        self.startDate = Date()
        self.fromGoalTime = goal
        self.fromSumTime = sum
        self.fromStopwatchTime = stopwatch
        self.fromTimerTime = 0
    }
    
    init(goal: Int, sum: Int, timer: Int) { // Timer 용 init
        self.startDate = Date()
        self.fromGoalTime = goal
        self.fromSumTime = sum
        self.fromTimerTime = timer
        self.fromStopwatchTime = 0
    }
}

extension Time {
    static func seconds(from: Date, to: Date) -> Int {
        let timeComponents = Calendar.current.dateComponents([.hour, .minute, .second], from: from, to: to)
        return (timeComponents.hour ?? 0)*3600 + (timeComponents.minute ?? 0)*60 + (timeComponents.second ?? 0)
    }
}
