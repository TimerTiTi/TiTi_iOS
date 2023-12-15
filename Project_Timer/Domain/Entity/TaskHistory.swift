//
//  TaskHistory.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2023/12/16.
//  Copyright © 2023 FDEE. All rights reserved.
//

import Foundation

struct TaskHistory: Codable, Equatable {
    var startDate: Date
    var endDate: Date
    var interval: Int {
        return Date.interval(from: startDate, to: endDate)
    }
    
    mutating func updateStartDate(to date: Date) {
        self.startDate = date
    }
    
    mutating func updateEndDate(to date: Date) {
        // endDate 값이 startDate 값보다 작은경우는 +1day 처리 후 저장
        if (date.compare(self.startDate) == .orderedAscending) {
            self.endDate = Calendar.current.date(byAdding: .day, value: 1, to: date)!
        } else {
            self.endDate = date
        }
    }
    
    static func ==(lhs: Self, rhs: Self) -> Bool {
        return lhs.startDate.YYYYMMDDHMSstyleString == rhs.startDate.YYYYMMDDHMSstyleString
            && lhs.endDate.YYYYMMDDHMSstyleString == rhs.endDate.YYYYMMDDHMSstyleString
    }
}
