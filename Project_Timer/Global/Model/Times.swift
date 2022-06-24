//
//  Times.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2022/04/29.
//  Copyright © 2022 FDEE. All rights reserved.
//

import Foundation

struct TimeLabel {
    let hourTens: Int
    let hourUnits: Int
    let minuteTens: Int
    let minuteUnits: Int
    let secondTens: Int
    let secondUnits: Int
}

struct Times {
    let sum: Int
    let timer: Int
    let stopwatch: Int
    let goal: Int
    
    static func hourFromSeconds(_ sec: Int) -> Int {
        return sec / 3600
    }
    
    static func minuteFromSeconds(_ sec: Int) -> Int {
        return (sec - sec/3600*3600) / 60
    }
    
    static func secondFromSeconds(_ sec: Int) -> Int {
        return sec % 60
    }
    
    static func toTimeLabel(_ sec: Int) -> TimeLabel {
        let hour = hourFromSeconds(sec)
        let minute = minuteFromSeconds(sec)
        let second = secondFromSeconds(sec)
        return TimeLabel(hourTens: hour / 10,
                         hourUnits: hour % 10,
                         minuteTens: minute / 10,
                         minuteUnits: minute % 10,
                         secondTens: second / 10,
                         secondUnits: second % 10)
    }
}
