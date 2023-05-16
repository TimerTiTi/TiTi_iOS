//
//  MonthWidgetData+Snapshot.swift
//  widgetExtension
//
//  Created by Kang Minsang on 2023/05/15.
//  Copyright © 2023 FDEE. All rights reserved.
//

import Foundation

extension MonthWidgetData {
    // MARK: Snapshot 제공을 위한 sample 데이터 반환
    static var snapshot: MonthWidgetData {
        let sampleTasks: [MonthWidgetTaskData] = [
            MonthWidgetTaskData(taskName: "sampleTask1".localized(), taskTime: 30*3600),
            MonthWidgetTaskData(taskName: "sampleTask2".localized(), taskTime: 25*3600),
            MonthWidgetTaskData(taskName: "sampleTask3".localized(), taskTime: 20*3600),
            MonthWidgetTaskData(taskName: "sampleTask4".localized(), taskTime: 15*3600),
            MonthWidgetTaskData(taskName: "sampleTask5".localized(), taskTime: 10*3600)
        ]
        let firstDay = Date().startDayOfMonth
        var sampleCellDatas: [MonthWidgetCellData] = []
        for i in 0...18 {
            sampleCellDatas.append(MonthWidgetCellData(recordDay: firstDay.nextDay(offset: i), totalTime: Int.random(in: 0...6*3600)))
        }
        
        return MonthWidgetData(color: 1, isRightDirection: true, tasksData: sampleTasks, cellsData: sampleCellDatas)
    }
}
