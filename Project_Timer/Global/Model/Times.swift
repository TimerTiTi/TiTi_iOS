//
//  Times.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2022/04/29.
//  Copyright © 2022 FDEE. All rights reserved.
//

import Foundation

struct Times {
    let sum: Int
    let timer: Int
    let stopwatch: Int
    let goal: Int
    let timerTaskGoal: Int?
    let stopwatchTaskGoal: Int?
    
    init(_ sum: Int, _ timer: Int, _ stopwatch: Int, _ goal: Int) {
        self.sum = sum
        self.timer = timer
        self.stopwatch = stopwatch
        self.goal = goal
        self.timerTaskGoal = nil
        self.stopwatchTaskGoal = nil
    }
    
    init(_ sum: Int, _ timer: Int, _ stopwatch: Int, _ goal: Int, _ timerTaskGoal: Int, _ stopwatchTaskGoal: Int) {
        self.sum = sum
        self.timer = timer
        self.stopwatch = stopwatch
        self.goal = goal
        self.timerTaskGoal = timerTaskGoal
        self.stopwatchTaskGoal = stopwatchTaskGoal
    }
}

struct TimeLabel {
    let hourTens: Int
    let hourUnits: Int
    let minuteTens: Int
    let minuteUnits: Int
    let secondTens: Int
    let secondUnits: Int
    
    init(_ sec: Int) {
        let second = sec % 60
        let hour = sec / 3600
        let minute = (sec / 60) - (hour * 60)
        
        self.hourTens = hour / 10
        self.hourUnits = hour % 10
        self.minuteTens = minute / 10
        self.minuteUnits = minute % 10
        self.secondTens = second / 10
        self.secondUnits = second % 10
    }
}
