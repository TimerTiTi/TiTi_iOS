//
//  TasksCircularProgressDTO.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2022/09/14.
//  Copyright © 2022 FDEE. All rights reserved.
//

import Foundation

struct TasksCircularProgressDTO {
    let blockValue = Float(0.003)
    let totalValue: Float
    var tasksAndBlocks: [Float] = []
    private let tasks: [TaskInfo]
    private var progressValue: Float = 1
    
    
    init(tasks: [TaskInfo]) {
        self.tasks = tasks.sorted(by: { $0.taskTime < $1.taskTime })
        self.totalValue = Float(tasks.reduce(0, { $0 + $1.taskTime })) + (blockValue * Float(tasks.count))
        self.configureTasksAndBlocks()
        print(progressValue)
    }
    
    mutating private func configureTasksAndBlocks() {
        for task in tasks {
            self.addBlock()
            self.addTask(task)
        }
    }
    
    mutating private func addBlock() {
        self.tasksAndBlocks.append(self.progressValue)
        self.progressValue -= blockValue
    }
    
    mutating private func addTask(_ task: TaskInfo) {
        self.tasksAndBlocks.append(self.progressValue)
        self.progressValue -= Float(task.taskTime)/totalValue
    }
}
