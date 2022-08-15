//
//  ModifyRecordVM.swift
//  Project_Timer
//
//  Created by 최수정 on 2022/08/14.
//  Copyright © 2022 FDEE. All rights reserved.
//

import Foundation

final class ModifyRecordVM {
    /* public */
    @Published private(set) var currentDaily: Daily?
    @Published private(set) var tasks: [TaskInfo] = []
    @Published var selectedTask: String?
    var selectedTaskHistorys: [TaskHistory] {
        guard let selectedTask = selectedTask,
              let daily = currentDaily,
              let taskHistorys = daily.taskHistorys,
              let selectedTaskHistorys = taskHistorys[selectedTask] else { return [] }

        return selectedTaskHistorys
    }
    let timelineVM: TimelineVM
    
    init() {
        self.timelineVM = TimelineVM()
    }
    
    func updateDaily(to daily: Daily?) {
        self.currentDaily = daily
        self.timelineVM.update(daily: daily)
        guard let tasks = daily?.tasks else {
            self.tasks = []
            return
        }
        self.tasks = tasks.sorted(by: { $0.value > $1.value })
            .map { TaskInfo(taskName: $0.key, taskTime: $0.value) }
    }
}
