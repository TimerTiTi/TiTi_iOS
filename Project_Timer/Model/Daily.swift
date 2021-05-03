//
//  Daily.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2021/04/06.
//  Copyright © 2021 FDEE. All rights reserved.
//

import UIKit
struct Daily: Codable {
    var day: Date = Date()
    var fixedTotalTime: Int = 0
    var fixedSumTime: Int = 0
    var fixedTimerTime: Int = 0
    var currentTotalTime: Int = 0
    var currentSumTime: Int = 0
    var currentTimerTime: Int = 0
    var breakTime: Int = 0
    
    var startTime: Date = Date()
    var currentTask: String = ""
    var tasks: [String:Int] = [:]
    
    mutating func startTask(_ task: String) {
        self.currentTask = task
        self.startTime = Date()
    }
    
    mutating func stopTask() {
        var value = tasks[currentTask] ?? 0
        value += getSeconds()
        tasks[currentTask] = value
    }
    
    mutating func reset() {
        self = Daily()
        save()
    }
    
    func getSeconds() -> Int {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.hour, .minute, .second], from: self.startTime, to: Date())
        let result = components.hour!*3600 + components.minute!*60 + components.second!
        return result
    }
    
    func save() {
        Storage.store(self, to: .documents, as: "daily.json")
    }
    
    mutating func load() {
        self = Storage.retrive("daily.json", from: .documents, as: Daily.self) ?? Daily()    }
}
