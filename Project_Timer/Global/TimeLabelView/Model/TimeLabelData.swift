//
//  TimeLabelData.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2023/03/20.
//  Copyright © 2023 FDEE. All rights reserved.
//

import Foundation

struct TimeLabelData {
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
