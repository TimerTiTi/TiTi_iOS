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
    var showWarningOfRecordDate: Bool = false
    
    private init() {
        self.recordTimes.load()
        self.daily.load()
        self.dailys.loadDailys()
        self.configureWarningOfRecordDate()
        NotificationCenter.default.addObserver(forName: .removeNewRecordWarning, object: nil, queue: .current) { [weak self] _ in
            self?.showWarningOfRecordDate = false
        }
    }
    
    private func configureWarningOfRecordDate() {
        let today = Date().YYYYMMDDstyleString
        if today != self.daily.day.YYYYMMDDstyleString {
            self.showWarningOfRecordDate = true
        }
    }
}
