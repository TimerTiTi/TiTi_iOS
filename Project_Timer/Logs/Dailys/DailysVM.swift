//
//  DailysVM.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2022/07/24.
//  Copyright © 2022 FDEE. All rights reserved.
//

import Foundation

final class DailysVM {
    /* public */
    @Published private(set) var currentDaily: Daily?
    @Published private(set) var tasks: [TaskInfo] = []
    let timelineVM: TimelineVM
    
    init() {
        self.timelineVM = TimelineVM()
    }
    
    func updateDaily(to daily: Daily?) {
        self.currentDaily = daily
        self.timelineVM.update(daily: daily)
    }
    
    func updateColor(isReverseColor: Bool) {
        self.timelineVM.updateColor(isReversColor: isReverseColor)
    }
}
