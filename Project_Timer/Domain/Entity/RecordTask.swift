//
//  RecordTask.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2022/10/23.
//  Copyright © 2022 FDEE. All rights reserved.
//

import Foundation

struct RecordTask: Codable, Equatable {
    var taskName: String
    var taskTargetTime: Int
    var isTaskTargetTimeOn: Bool
    
    init(_ taskName: String, _ taskTargetTime: Int, _ isTaskTargetTimeOn: Bool) {
        self.taskName = taskName
        self.taskTargetTime = taskTargetTime
        self.isTaskTargetTimeOn = isTaskTargetTimeOn
    }
    
    init(_ taskName: String) {
        self.taskName = taskName
        self.taskTargetTime = 3600
        self.isTaskTargetTimeOn = false
    }
    
    mutating func update(taskName: String) {
        self.taskName = taskName
    }
    
    mutating func update(taskTime: Int) {
        self.taskTargetTime = taskTime
    }
    
    mutating func update(isOn: Bool) {
        self.isTaskTargetTimeOn = isOn
    }
    
    static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.taskName == rhs.taskName
    }
}
