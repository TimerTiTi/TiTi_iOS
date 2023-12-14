//
//  TimeTableVM.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2023/01/06.
//  Copyright © 2023 FDEE. All rights reserved.
//

import Foundation

final class TimeTableVM: ObservableObject {
    @Published var blocks: [TimeTableBlock] = []
    private var userColorIndex: Int = 1
    private var isReversColor: Bool = false
    private var taskHistorys: [String: [TaskHistory]] = [:]
    private var tasks: [TaskInfo] = []
    
    init(isPreview: Bool = false) {
        self.updateColor()
        if isPreview {
            let daily = Daily.testInfo
            let tasks = daily.tasks.sorted(by: { $0.value > $1.value })
                .map { TaskInfo(taskName: $0.key, taskTime: $0.value) }
            self.update(daily: Daily.testInfo, tasks: tasks)
        }
    }
    
    func update(daily: Daily?, tasks: [TaskInfo]) {
        guard let taskHistorys = daily?.taskHistorys else {
            self.blocks = []
            return
        }
        self.taskHistorys = taskHistorys
        self.tasks = tasks
        self.updateBlocks()
    }
    
    func updateColor() {
        self.userColorIndex = UserDefaultsManager.get(forKey: .startColor) as? Int ?? 1
        self.isReversColor = UserDefaultsManager.get(forKey: .reverseColor) as? Bool ?? false
        self.updateBlocks()
    }
}

extension TimeTableVM {
    private func updateBlocks() {
        var blocks: [TimeTableBlock] = []
        var id: Int = 0
        self.taskHistorys.forEach { taskName, historys in
            let taskIndex = tasks.firstIndex(where: { $0.taskName == taskName }) ?? 0
            let rawIndex = self.isReversColor
            ? self.userColorIndex-taskIndex
            : self.userColorIndex+taskIndex
            
            historys.forEach { history in
                // startDate, endDate 가 동일 시간대인 경우
                let startHour = history.startDate.hour
                let endHour = startHour + (history.interval + history.startDate.seconds)/3600
                
                // MARK: 동시간대의 기록
                if (startHour == endHour) {
                    blocks.append(TimeTableBlock(id: id,
                                                 colorIndex: rawIndex.colorIndex,
                                                 hour: startHour%24,
                                                 startSeconds: history.startDate.seconds,
                                                 interver: min(3600, history.interval)))
                    id += 1
                    return
                }
                
                // MARK: 시간대가 다른 경우: hour%24 위치에 block 추가
                blocks.append(TimeTableBlock(id: id,
                                             colorIndex: rawIndex.colorIndex,
                                             hour: startHour%24,
                                             startSeconds: history.startDate.seconds,
                                             interver: min(3600, 3600 - history.startDate.seconds)))
                id += 1
                
                for h in startHour+1..<endHour {
                    blocks.append(TimeTableBlock(id: id,
                                                 colorIndex: rawIndex.colorIndex,
                                                 hour: h%24,
                                                 startSeconds: 0,
                                                 interver: 3600))
                    id += 1
                }
                
                blocks.append(TimeTableBlock(id: id,
                                             colorIndex: rawIndex.colorIndex,
                                             hour: endHour%24,
                                             startSeconds: 0,
                                             interver: min(3600, history.endDate.seconds)))
                id += 1
            }
        }
        
        self.blocks = blocks
            .sorted(by: { $0.id > $1.id })
            .sorted(by: { $0.interver > $1.interver })
    }
}
