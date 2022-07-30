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
    
    func selectDate(to date: Date) {
        let weekData = DailysWeekData(selectedDate: date, dailys: RecordController.shared.dailys.dailys)
        dump(weekData)
    }
}
