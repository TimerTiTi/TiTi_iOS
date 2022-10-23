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
    static let fileName = "tasks.json"
    @Published private(set) var tasks: [Task] = []
    
    init() {
        self.loadTasks()
    }
    
    private func loadTasks() {
        self.tasks = Storage.retrive(Self.fileName, from: .documents, as: [Task].self) ?? []
        if self.tasks.isEmpty {
            self.loadFromUserDefaults()
        }
    }
    
    private func loadFromUserDefaults() {
        let taskNames = UserDefaults.standard.value(forKey: "tasks") as? [String] ?? []
        guard taskNames.isEmpty == false else { return }
        self.tasks = taskNames.map { Task($0) }
    }
    
    private func saveTasks() {
        Storage.store(self.tasks, to: .documents, as: Self.fileName)
    }
    
    func addNewTask(taskName: String) {
        let newTask = Task(taskName)
        self.tasks.append(newTask)
        self.saveTasks()
    }
    
    func deleteTask(at index: Int) {
        guard let targetTask = self.tasks[safe: index] else { return }
        self.tasks.removeAll(where: { $0.taskName == targetTask.taskName })
        self.saveTasks()
    }
    
    func updateTaskName(at index: Int, to text: String) {
        guard self.tasks[safe: index] != nil else { return }
        self.tasks[index].update(taskName: text)
        self.saveTasks()
    }
    
    func updateTaskTime(at index: Int, to time: Int) {
        guard self.tasks[safe: index] != nil else { return }
        self.tasks[index].update(taskTime: time)
        self.saveTasks()
    }
    
    func updateTaskOn(at index: Int, to isOn: Bool) {
        guard self.tasks[safe: index] != nil else { return }
        self.tasks[index].update(isOn: isOn)
        self.saveTasks()
    }
    
    func moveTask(fromIndex: Int, toIndex: Int) {
        var tasks = self.tasks
        let targetTask = tasks.remove(at: fromIndex)
        tasks.insert(targetTask, at: toIndex)
        self.tasks = tasks
        self.saveTasks()
    }
}
