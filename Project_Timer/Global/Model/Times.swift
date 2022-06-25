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
}

struct TimeLabel {
    let hourTens: Int
    let hourUnits: Int
    let minuteTens: Int
    let minuteUnits: Int
    let secondTens: Int
    let secondUnits: Int
    
    static func toTimeLabel(_ sec: Int) -> TimeLabel {
        let second = sec % 60
        let hour = sec / 3600
        let minute = (sec / 60) - (hour * 60)
        
        return TimeLabel(hourTens: hour / 10,
                         hourUnits: hour % 10,
                         minuteTens: minute / 10,
                         minuteUnits: minute % 10,
                         secondTens: second / 10,
                         secondUnits: second % 10)
    }
}
