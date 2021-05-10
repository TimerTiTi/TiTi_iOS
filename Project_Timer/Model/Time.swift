//
//  Time.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2021/02/28.
//  Copyright © 2021 FDEE. All rights reserved.
//

//맥용 저장을 위한 구조 새로작성
import UIKit
struct Time {
    var startTime: Date? = nil
    var startGoalTime: Int = 0
    var startSumTime: Int = 0
    var startTimerTime: Int = 0
    var startSumTimeTemp: Int = 0
    
    init() {
        self.startTime = nil
        self.startGoalTime = 0
        self.startSumTime = 0
        self.startTimerTime = 0
    }
    
    mutating func setTimes(goal: Int, sum: Int, timer: Int) {
        self.startTime = Date()
        self.startGoalTime = goal
        self.startSumTime = sum
        self.startTimerTime = timer
    }
    
    func getSeconds() -> Int {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.hour, .minute, .second], from: self.startTime!, to: Date())
        let result = components.hour!*3600 + components.minute!*60 + components.second!
        return result
    }
}
