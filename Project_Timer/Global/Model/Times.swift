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
    let remainingTaskTime: Int
    let timerForDarker: Int
    
    init(_ sum: Int, _ timer: Int, _ stopwatch: Int, _ goal: Int, _ remainingTaskTime: Int, darkerMode: Bool = false) {
        self.sum = darkerMode ? sum - sum%60 : sum
        self.timer = timer
        self.stopwatch = darkerMode ? stopwatch - stopwatch%60 : stopwatch
        self.goal = darkerMode ? goal - goal%60 : goal
        self.remainingTaskTime = darkerMode ? remainingTaskTime - remainingTaskTime%60 : remainingTaskTime
        self.timerForDarker = timer%60 == 0 ? timer : timer - timer%60 + 60
    }
}
