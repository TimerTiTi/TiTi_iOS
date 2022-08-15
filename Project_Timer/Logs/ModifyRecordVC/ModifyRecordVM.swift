//
//  ModifyRecordVM.swift
//  Project_Timer
//
//  Created by 최수정 on 2022/08/14.
//  Copyright © 2022 FDEE. All rights reserved.
//

import Foundation
import Combine

final class ModifyRecordVM {
    @Published private(set) var currentDaily: Daily
    @Published private(set) var tasks: [TaskInfo] = []
    @Published var selectedTask: String?
    var selectedTaskHistorys: [TaskHistory] {
        guard let selectedTask = selectedTask,
              let taskHistorys = currentDaily.taskHistorys,
              let selectedTaskHistorys = taskHistorys[selectedTask] else { return [] }

        return selectedTaskHistorys
    }
    
    let timelineVM: TimelineVM
    private var cancellables: Set<AnyCancellable> = []
    
    init(daily: Daily) {
        self.currentDaily = daily
        self.timelineVM = TimelineVM()
        
        self.$currentDaily
            .receive(on: DispatchQueue.main)
            .sink { [weak self] daily in
                self?.timelineVM.update(daily: daily)
                self?.tasks = daily.tasks.sorted(by: { $0.value > $1.value })
                    .map { TaskInfo(taskName: $0.key, taskTime: $0.value) }
            }
            .store(in: &self.cancellables)
    }
}

extension ModifyRecordVM {
    func updateSelectedTaskName(to newName: String) {
        guard let oldName = selectedTask,
              oldName != newName,
              self.currentDaily.tasks[newName] == nil else { return }
        
        self.currentDaily.changeTaskName(from: oldName, to: newName)
        self.selectedTask = newName
    }
}
