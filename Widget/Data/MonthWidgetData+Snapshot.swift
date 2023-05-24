//
//  MonthWidgetData+Snapshot.swift
//  widgetExtension
//
//  Created by Kang Minsang on 2023/05/15.
//  Copyright © 2023 FDEE. All rights reserved.
//

import Foundation

extension CalendarWidgetData {
    // MARK: Snapshot 제공을 위한 sample 데이터 반환
    static var snapshot: CalendarWidgetData {
        let sampleTasks: [CalendarWidgetTaskData] = [
            CalendarWidgetTaskData(taskName: "sampleTask1".localizedForWidget(), taskTime: 30*3600),
            CalendarWidgetTaskData(taskName: "sampleTask2".localizedForWidget(), taskTime: 25*3600),
            CalendarWidgetTaskData(taskName: "sampleTask3".localizedForWidget(), taskTime: 20*3600),
            CalendarWidgetTaskData(taskName: "sampleTask4".localizedForWidget(), taskTime: 15*3600),
            CalendarWidgetTaskData(taskName: "sampleTask5".localizedForWidget(), taskTime: 10*3600)
        ]
        let firstDay = Date().startDayOfMonth
        var sampleCellDatas: [CalendarWidgetCellData] = []
        for i in 0...18 {
            sampleCellDatas.append(CalendarWidgetCellData(recordDay: firstDay.nextDay(offset: i), totalTime: Int.random(in: 0...6*3600)))
        }
        
        return CalendarWidgetData(color: 1, isReverseColor: true, targetTime: 6*3600, tasksData: sampleTasks, cellsData: sampleCellDatas)
    }
}
