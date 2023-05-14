//
//  Date+Extension.swift
//  widgetExtension
//
//  Created by Kang Minsang on 2023/05/14.
//  Copyright © 2023 FDEE. All rights reserved.
//

import Foundation

// MARK: properties based https://github.com/simonberner/calendar-widget project
extension Date {
    /// 이번달 첫날
    var startDayOfMonth: Date {
        return Calendar.current.dateInterval(of: .month, for: self)!.start
    }
    
    /// 다음달 첫날
    var startDayOfNextMonth: Date {
        return Calendar.current.dateInterval(of: .month, for: self)!.end
    }
    
    /// 이번달 마지막날
    var lastDayOfMonth: Date {
        return Calendar.current.date(byAdding: .day, value: -1, to: startDayOfNextMonth)!
    }

    /// 이전달 첫날
    var startDayOfPreviousMonth: Date {
        let previousMonthDay = Calendar.current.date(byAdding: .month, value: -1, to: self)!
        return previousMonthDay.startDayOfMonth
    }

    /// 달의 날짜수
    var numberOfDaysInMonth: Int {
        return Calendar.current.component(.day, from: self.lastDayOfMonth)
    }

    /// 날짜
    var dayInt: Int {
        Calendar.current.component(.day, from: self)
    }

    /// 달
    var monthInt: Int {
        Calendar.current.component(.month, from: self)
    }

    /// 달
    var monthFullName: String {
        self.formatted(.dateTime.month(.wide))
    }
    
    /// 날짜 인덱스 (일: 1 ~ 토: 7)
    var indexFromSundayOne: Int {
        return Calendar.current.component(.weekday, from: self)
    }
    
    /// 날짜 인덱스 (월: 0 ~ 토: 6)
    var indexFromMondayZero: Int {
        return (self.indexFromSundayOne+5)%7
    }
    
    /// 이번달 시작하는 주의 월요일 날짜
    var startMondayForCalendar: Date {
        let indexOfStartDay = startDayOfMonth.indexFromMondayZero
        return Calendar.current.date(byAdding: .day, value: -indexOfStartDay, to: startDayOfMonth)!
    }
}
