//
//  RecordController.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2022/04/29.
//  Copyright © 2022 FDEE. All rights reserved.
//

import Foundation

final class RecordController {
    static let shared = RecordController()
    var recordTimes = RecordTimes()
    var daily = Daily()
    var dailys = DailyViewModel()
    
    private init() {
        self.recordTimes.load()
        self.daily.load()
        self.dailys.loadDailys()
    }
}
