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
        dateFormatter.dateFormat = "YYYY.MM.dd"
        let transedDate: Date = dateFormatter.date(from: dateFormatter.string(from: self))!
        return transedDate
    }
    /// 해당날짜가 속한 달의 몇번째 주차인지를 나타내는 값
    var weekOfMonth: Int {
        var calendar = Calendar(identifier: .gregorian)
//        calendar.locale = Locale(identifier: "ko")
        return(calendar.component(.weekOfMonth, from: self))
    }
    
    var YYYYMMDDHMSstyleString: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy.MM.dd HH:mm:ss"
        return dateFormatter.string(from: self)
    }
    
    static func interval(from: Date, to: Date) -> Int {
        let timeComponents = Calendar.current.dateComponents([.hour, .minute, .second], from: from, to: to)
        return (timeComponents.hour ?? 0)*3600 + (timeComponents.minute ?? 0)*60 + (timeComponents.second ?? 0)
    }
    
    var truncateSeconds: Date? {
        return Calendar.current.date(from: Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: self))
    }
}
