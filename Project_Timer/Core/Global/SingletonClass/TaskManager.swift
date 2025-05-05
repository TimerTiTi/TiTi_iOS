//
//  TaskManager.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2023/03/24.
//  Copyright © 2023 FDEE. All rights reserved.
//

import Foundation

final class TaskManager {
    static let fileName = "tasks.json"
    var tasks: [RecordTask] = [] {
        didSet {
            self.saveTasks()
        }
    }
    
    func loadTasks() {
        self.tasks = Storage.retrive(Self.fileName, from: .documents, as: [RecordTask].self) ?? []
        if self.tasks.isEmpty {
            self.loadFromUserDefaults()
        }
    }
    
    private func loadFromUserDefaults() {
        let taskNames = UserDefaults.standard.value(forKey: "tasks") as? [String] ?? []
        guard taskNames.isEmpty == false else { return }
        self.tasks = taskNames.map { RecordTask($0) }
    }
    
    private func saveTasks() {
        Storage.store(self.tasks, to: .documents, as: TaskManager.fileName)
    }
    
    func addNewTask(taskName: String) {
        let newTask = RecordTask(taskName)
        self.tasks.append(newTask)
    }
    
    func deleteTask(at index: Int) {
        guard let targetTask = self.tasks[safe: index] else { return }
        self.tasks.removeAll(where: { $0.taskName == targetTask.taskName })
    }
    
    func updateTaskName(at index: Int, to text: String) {
        guard self.tasks[safe: index] != nil else { return }
        self.tasks[index].update(taskName: text)
    }
    
    func updateTaskTime(at index: Int, to time: Int) {
        guard self.tasks[safe: index] != nil else { return }
        self.tasks[index].update(taskTime: time)
    }
    
    func updateTaskOn(at index: Int, to isOn: Bool) {
        guard self.tasks[safe: index] != nil else { return }
        self.tasks[index].update(isOn: isOn)
    }
    
    func moveTask(fromIndex: Int, toIndex: Int) {
        var tasks = self.tasks
        let targetTask = tasks.remove(at: fromIndex)
        tasks.insert(targetTask, at: toIndex)
        self.tasks = tasks
    }
}
