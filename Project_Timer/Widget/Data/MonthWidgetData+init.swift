//
//  MonthWidgetData+Init.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2023/05/16.
//  Copyright © 2023 FDEE. All rights reserved.
//

import Foundation

extension MonthWidgetData {
    init(dailys: [Daily]) {
        self.color = UserDefaultsManager.get(forKey: .monthWidgetColor) as? Int ?? 1
        self.isRightDirection = UserDefaultsManager.get(forKey: .reverseColor) as? Bool ?? false
        
        let monthDailys = dailys.filter { $0.day.YYMMstyleInt == Date().YYMMstyleInt }.sorted { $0.day < $1.day }
        var tasks: [String: Int] = [:]
        for daily in monthDailys {
            daily.tasks.forEach { taskName, taskTime in
                if let sum = tasks[taskName] {
                    tasks[taskName] = sum + taskTime
                } else {
                    tasks[taskName] = taskTime
                }
            }
        }
        
        self.tasksData = Array(tasks.sorted { $0.value > $1.value }
            .map { MonthWidgetTaskData(taskName: $0.key, taskTime: $0.value)}
            .prefix(5))
        self.cellsData = monthDailys.map { MonthWidgetCellData(recordDay: $0.day.calendarDay, totalTime: $0.totalTime)}
    }
}
