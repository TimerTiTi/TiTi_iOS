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
            MonthWidgetTaskData(taskName: "국어", taskTime: 30),
            MonthWidgetTaskData(taskName: "수학", taskTime: 25),
            MonthWidgetTaskData(taskName: "영어", taskTime: 20),
            MonthWidgetTaskData(taskName: "한국사", taskTime: 15),
            MonthWidgetTaskData(taskName: "탐구", taskTime: 10)
        ]
        let firstDay = Date().startDayOfMonth
        var sampleCellDatas: [MonthWidgetCellData] = []
        for i in 0...14 {
            sampleCellDatas.append(MonthWidgetCellData(recordDay: firstDay.nextDay(offset: i), totalTime: Int.random(in: 0...6*3600)))
        }
        
        return MonthWidgetData(color: .D1, isRightDirection: true, tasksData: sampleTasks, cellsData: sampleCellDatas)
    }
}
