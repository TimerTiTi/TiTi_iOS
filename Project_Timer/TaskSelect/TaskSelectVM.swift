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
    @Published private(set) var tasks: [Task] = [] {
        didSet {
            RecordController.shared.tasks = self.tasks
            self.saveTasks()
        }
    }
    @Published private(set) var selectedTask: String?
    
    init() {
        self.loadTasks()
    }
    
    private func loadTasks() {
        self.tasks = RecordController.shared.tasks
    }
    
    private func saveTasks() {
        Storage.store(self.tasks, to: .documents, as: Task.fileName)
    }
    
    func addNewTask(taskName: String) {
        let newTask = Task(taskName)
        self.tasks.append(newTask)
    }
    
    func deleteTask(at index: Int) {
        guard let targetTask = self.tasks[safe: index] else { return }
        self.tasks.removeAll(where: { $0.taskName == targetTask.taskName })
    }
    
    func isSameNameExist(name: String) -> Bool {
        return self.tasks.map(\.taskName).contains(name)
    }
    
    func updateTaskName(at index: Int, to text: String) {
        guard self.tasks[safe: index] != nil else { return }
        self.resetTaskname(before: self.tasks[index].taskName, after: text)
        self.tasks[index].update(taskName: text)
    }
    
    func updateTaskTime(at index: Int, to time: Int) {
        guard self.tasks[safe: index] != nil else { return }
        self.tasks[index].update(taskTime: time)
    }
    
    func updateTaskOn(at index: Int, to isOn: Bool) {
        guard self.tasks[safe: index] != nil else { return }
        self.tasks[index].update(isOn: isOn)
        
        if let currentTask = RecordController.shared.currentTask, currentTask == self.tasks[index] {
            self.selectedTask = currentTask.taskName
        }
    }
    
    func moveTask(fromIndex: Int, toIndex: Int) {
        var tasks = self.tasks
        let targetTask = tasks.remove(at: fromIndex)
        tasks.insert(targetTask, at: toIndex)
        self.tasks = tasks
    }
    
    private func resetTaskname(before: String, after: String) {
        let currentTask = RecordController.shared.recordTimes.recordTask
        var tasks = RecordController.shared.daily.tasks
        
        if let beforeTime = tasks[before] {
            tasks.removeValue(forKey: before)
            tasks[after] = beforeTime
            RecordController.shared.daily.updateTasks(to: tasks)
            RecordController.shared.dailys.modifyDaily(RecordController.shared.daily)
        }
        
        if currentTask == before {
            self.selectedTask = after
        }
    }
}
