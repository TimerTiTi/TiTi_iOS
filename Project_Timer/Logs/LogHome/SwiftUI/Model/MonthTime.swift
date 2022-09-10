//
//  MonthTime.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2022/09/06.
//  Copyright © 2022 FDEE. All rights reserved.
//

import Foundation

struct MonthTime {
    let totalTime: Int
    let maxTime: Int
    let colorIndex: Int
    let reverseColor: Bool
    let top5TotalTime: Int
    let top5Tasks: [TaskInfo]
    
    init(baseDate: Date = Date(), dailys: [Daily], isReverseColor: Bool) {
        var sumTotalTime: Int = 0
        var tasks: [String: Int] = [:]
        let baseYYMM = baseDate.YYMMstyleInt
        dailys.filter{ $0.day.YYMMstyleInt == baseYYMM }.forEach { daily in
            sumTotalTime += daily.totalTime
            daily.tasks.forEach { key, value in
                if let sum = tasks[key] {
                    tasks[key] = sum + value
                } else {
                    tasks[key] = value
                }
            }
        }
        
        self.totalTime = sumTotalTime
        self.maxTime = UserDefaultsManager.get(forKey: .goalTimeOfMonth) as? Int ?? 360000
        self.colorIndex = UserDefaultsManager.get(forKey: .startColor) as? Int ?? 1
        self.reverseColor = isReverseColor
        let top5Tasks = Array(tasks.sorted { $0.value > $1.value }
            .map { TaskInfo(taskName: $0.key, taskTime: $0.value) }
            .prefix(5))
        self.top5TotalTime = top5Tasks.reduce(0, { $0 + $1.taskTime })
        self.top5Tasks = top5Tasks
    }
}
