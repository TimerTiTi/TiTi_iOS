//
//  TaskManager.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2023/03/24.
//  Copyright © 2023 FDEE. All rights reserved.
//

import Foundation

final class TaskManager {
    var tasks: [Task] = []
    
    func loadTasks() {
        self.tasks = Storage.retrive(Task.fileName, from: .documents, as: [Task].self) ?? []
        if self.tasks.isEmpty {
            self.loadFromUserDefaults()
        }
    }
    
    private func loadFromUserDefaults() {
        let taskNames = UserDefaults.standard.value(forKey: "tasks") as? [String] ?? []
        guard taskNames.isEmpty == false else { return }
        self.tasks = taskNames.map { Task($0) }
    }
}
