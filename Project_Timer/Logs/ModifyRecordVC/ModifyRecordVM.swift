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
    let timelineVM: TimelineVM
    
    init() {
        self.timelineVM = TimelineVM()
    }
}
