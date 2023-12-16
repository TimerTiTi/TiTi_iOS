//
//  LogWeekVM.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2022/07/30.
//  Copyright © 2022 FDEE. All rights reserved.
//

import Foundation

final class LogWeekVM {
    /* public */
    @Published private(set) var weekData: WeekDailysData?
    @Published private(set) var top5Tasks: [TaskInfo] = []
    let timelineVM: WeekTimelineVM
    var selectedDate: Date = Date().zeroDate
    
    init() {
        self.timelineVM = WeekTimelineVM()
    }
    
    func selectDate(to date: Date) {
        let weekData = WeekDailysData(selectedDate: date, dailys: RecordsManager.shared.dailyManager.dailys)
        self.weekData = weekData
        self.timelineVM.update(weekData: weekData)
        self.top5Tasks = weekData.top5Tasks
    }
    
    func updateCurrentDate() {
        self.selectDate(to: self.selectedDate.zeroDate.localDate)
    }
    
    func updateColor() {
        self.timelineVM.updateColor()
    }
}
