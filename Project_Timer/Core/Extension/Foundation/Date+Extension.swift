//
//  Date+Extension.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2022/03/14.
//  Copyright © 2022 FDEE. All rights reserved.
//

import Foundation

extension Date {
    var MDstyleString: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "M/d"
        return dateFormatter.string(from: self)
    }
    
    var MMDDstyleString: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM.dd"
        return dateFormatter.string(from: self)
    }
    
    var YYYYMMDDstyleString: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy.MM.dd"
        return dateFormatter.string(from: self)
    }
    
    var YYYYMMstypeString: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy.MM"
        return dateFormatter.string(from: self)
    }
    
    var HHmmssStyleString: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm:ss"
        return dateFormatter.string(from: self)
    }
    
    func isSameDate(with date: Date) -> Bool {
        return self.YYYYMMDDstyleString == date.YYYYMMDDstyleString
    }
    
    var month: Int {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM"
        return Int(dateFormatter.string(from: self)) ?? 0
    }
    
    var hour: Int {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH"
        return Int(dateFormatter.string(from: self)) ?? 0
    }
    
    var YYMMstyleInt: Int {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyMM"
        return Int(dateFormatter.string(from: self)) ?? 0
    }
    
    var indexDayOfWeek: Int {
        // MARK: 0: Mun, 6: Sun 값으로 index 변환하여 반환
        return ((Calendar.current.component(.weekday, from: self) - 2) + 7) % 7
    }
    
    var localDate: Date {
        let timeZoneOffset = Double(TimeZone.current.secondsFromGMT(for: self))
        return Calendar.current.date(byAdding: .second, value: Int(timeZoneOffset), to: self) ?? self
    }
    /// 0분0초의 Date로 변환
    var zeroDate: Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy.MM.dd"
        let transedDate: Date = dateFormatter.date(from: dateFormatter.string(from: self))!
        return transedDate
    }
    /// 캘린더기준 오늘날
    var calendarDay: Date {
        return Calendar.current.dateInterval(of: .day, for: self)!.start
    }
    /// 해당날짜가 속한 달의 몇번째 주차인지를 나타내는 값
    var weekOfMonth: Int {
        let calendar = Calendar(identifier: .gregorian)
        return(calendar.component(.weekOfMonth, from: self))
    }
    
    var YYYYMMDDHMString: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy.MM.dd HH:mm"
        return dateFormatter.string(from: self)
    }
    
    var YYYYMMDDHMSstyleString: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy.MM.dd HH:mm:ss"
        return dateFormatter.string(from: self)
    }
    
    var serverDateString: String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US")
        dateFormatter.dateFormat = "yyyy.MM.dd a hh:mm:ss"
        return dateFormatter.string(from: self)
    }
    
    static func interval(from: Date, to: Date) -> Int {
        let timeComponents = Calendar.current.dateComponents([.hour, .minute, .second], from: from, to: to)
        return (timeComponents.hour ?? 0)*3600 + (timeComponents.minute ?? 0)*60 + (timeComponents.second ?? 0)
    }
    
    var truncateSeconds: Date? {
        return Calendar.current.date(from: Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: self))
    }
    
    var seconds: Int {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "mm"
        let M = Int(dateFormatter.string(from: self))! //분
        dateFormatter.dateFormat = "ss"
        let S = Int(dateFormatter.string(from: self))! //초
        return M*60+S
    }
    
    func setTime(hour: Int = 0, minute: Int = 0, second: Int = 0) -> Date {
        var components = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: self)
        components.hour = hour
        components.minute = minute
        components.second = second
        return Calendar.current.date(from: components)!
    }
}
