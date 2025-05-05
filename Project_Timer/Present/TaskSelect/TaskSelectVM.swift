//
//  TaskSelectVM.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2022/10/23.
//  Copyright © 2022 FDEE. All rights reserved.
//

import Foundation
import Combine

final class TaskSelectVM {
    let manager: TaskManager
    @Published private(set) var tasks: [Task] = []
    @Published private(set) var selectedTask: String?
    init() {
        self.manager = RecordsManager.shared.taskManager
        self.tasks = manager.tasks
    }
    
    func addNewTask(taskName: String) {
        manager.addNewTask(taskName: taskName)
        self.tasks = manager.tasks
    }
    
    func deleteTask(at index: Int) {
        manager.deleteTask(at: index)
        self.tasks = manager.tasks
    }
    
    func updateTaskName(at index: Int, to text: String) {
        guard manager.tasks[safe: index] != nil else { return }
        self.resetTaskname(before: manager.tasks[index].taskName, after: text)
        manager.updateTaskName(at: index, to: text)
        self.tasks = manager.tasks
    }
    
    func isSameNameExist(name: String) -> Bool {
        return manager.tasks.map(\.taskName).contains(name)
    }
    
    func updateTaskTime(at index: Int, to time: Int) {
        manager.updateTaskTime(at: index, to: time)
        self.tasks = manager.tasks
        self.updateSelectedTask(index: index)
    }
    
    func updateTaskOn(at index: Int, to isOn: Bool) {
        manager.updateTaskOn(at: index, to: isOn)
        self.tasks = manager.tasks
        self.updateSelectedTask(index: index)
    }
    
    func moveTask(fromIndex: Int, toIndex: Int) {
        manager.moveTask(fromIndex: fromIndex, toIndex: toIndex)
        self.tasks = manager.tasks
    }
}

extension TaskSelectVM {
    private func resetTaskname(before: String, after: String) {
        let currentTask = RecordsManager.shared.recordTimes.recordTask
        var tasks = RecordsManager.shared.dailyManager.currentDaily.tasks
        
        if let beforeTime = tasks[before] {
            tasks.removeValue(forKey: before)
            tasks[after] = beforeTime
            RecordsManager.shared.dailyManager.currentDaily.updateTasks(to: tasks)
            RecordsManager.shared.dailyManager.modifyDaily(RecordsManager.shared.dailyManager.currentDaily)
        }
        
        if currentTask == before {
            self.selectedTask = after
        }
    }
    
    private func updateSelectedTask(index: Int) {
        if let currentTask = RecordsManager.shared.currentTask,
            currentTask == self.tasks[index] {
            self.selectedTask = currentTask.taskName
        }
    }
}
