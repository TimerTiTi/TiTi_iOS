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
    
    init() {
        self.updateColor()
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
            var rawIndex = self.isReversColor
            ? self.userColorIndex+taskIndex
            : self.userColorIndex-taskIndex
            
            historys.forEach { history in
                // startDate, endDate 가 동일 시간대인 경우
                if (history.startDate.hour == history.endDate.hour) {
                    blocks.append(TimeTableBlock(id: id,
                                                 colorIndex: rawIndex.colorIndex,
                                                 hour: history.startDate.hour,
                                                 startSeconds: history.startDate.seconds,
                                                 interver: history.interval))
                    id += 1
                    return
                }
                
                // 시간대가 달라진 경우 둘이상으로 쪼개야 한다.
                blocks.append(TimeTableBlock(id: id,
                                             colorIndex: rawIndex.colorIndex,
                                             hour: history.startDate.hour,
                                             startSeconds: history.startDate.seconds,
                                             interver: 3600 - history.startDate.seconds))
                id += 1
                
                for h in history.startDate.hour+1...history.endDate.hour {
                    if h != history.endDate.hour {
                        blocks.append(TimeTableBlock(id: id,
                                                     colorIndex: rawIndex.colorIndex,
                                                     hour: h,
                                                     startSeconds: 0,
                                                     interver: 3600))
                        id += 1
                    } else {
                        blocks.append(TimeTableBlock(id: id,
                                                     colorIndex: rawIndex.colorIndex,
                                                     hour: h,
                                                     startSeconds: 0,
                                                     interver: history.endDate.seconds))
                        id += 1
                    }
                }
                
            }
        }
        
        self.blocks = blocks
    }
}
