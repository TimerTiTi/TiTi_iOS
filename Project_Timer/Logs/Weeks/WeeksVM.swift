//
//  WeeksVM.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2022/07/30.
//  Copyright © 2022 FDEE. All rights reserved.
//

import Foundation

final class WeeksVM {
    /* public */
    @Published private(set) var weekData: DailysWeekData?
    @Published private(set) var top5Tasks: [TaskInfo] = []
    let timelineVM: WeekTimelineVM
    var selectedDate: Date = Date().zeroDate
    
    init() {
        self.timelineVM = WeekTimelineVM()
    }
    
    func selectDate(to date: Date) {
        let weekData = DailysWeekData(selectedDate: date, dailys: RecordController.shared.dailys.dailys)
        self.weekData = weekData
        self.timelineVM.update(weekData: weekData)
        self.top5Tasks = weekData.top5Tasks
    }
    
    func updateCurrentDate() {
        self.selectDate(to: self.selectedDate.localDate)
    }
    
    func updateColor(isReverseColor: Bool) {
        self.timelineVM.updateColor(isReversColor: isReverseColor)
    }
}
