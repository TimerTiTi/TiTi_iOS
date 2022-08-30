//
//  Dummy.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2021/06/19.
//  Copyright © 2021 FDEE. All rights reserved.
//

import Foundation
struct Dummy {
    static func getTasks() -> [String:Int] {
        var dumy: [String:Int] = [:]
        dumy.updateValue(9200, forKey: "Swift Programming")
        dumy.updateValue(4820, forKey: "Study Algorithm")
        dumy.updateValue(2170, forKey: "Running")
        dumy.updateValue(1500, forKey: "Cycling")
        dumy.updateValue(700, forKey: "Reading Book")
        dumy.updateValue(607, forKey: "Learning Korean")
        return dumy
    }
    
    static func getTimelines() -> [Int] {
        let timeline = [3000,1800,0,0,0,0,0,0,0,1200,2000,3000,2600,1800,3000,3600,1000,0,500,2000,800,0,300,1200]
        return timeline
    }
    
    static func get7Dailys() -> [daily] {
        var DailyDatas: [daily] = []
        DailyDatas.append(daily(day: "6/14", studyTime: Converter.translate2(input: "3:37:20")))
        DailyDatas.append(daily(day: "6/15", studyTime: Converter.translate2(input: "2:58:23")))
        DailyDatas.append(daily(day: "6/16", studyTime: Converter.translate2(input: "6:02:07")))
        DailyDatas.append(daily(day: "6/17", studyTime: Converter.translate2(input: "4:03:39")))
        DailyDatas.append(daily(day: "6/18", studyTime: Converter.translate2(input: "3:35:15")))
        DailyDatas.append(daily(day: "6/19", studyTime: Converter.translate2(input: "5:10:12")))
        DailyDatas.append(daily(day: "6/20", studyTime: Converter.translate2(input: "5:19:19")))
        
        return DailyDatas
    }
    
    static func getDumyDaily() -> Daily {
//        let daily = Daily(day: Date(), tasks: [
//            "SwiftUI 스터디" : 3612,
//            "독서-린스타트업": 2854,
//            "세모문 개발": 6540,
//            "코테 구현": 2300,
//            "TiTi 개발": 3853
//        ], maxTime: 3612, timeline: [
//            0, 0, 0, 0, 0, 0, 0, 0, 0, 1500, 3600, 2700, 2520, 0, 600, 3600, 3600, 3120, 2400, 780, 0, 0, 2520, 3450
//        ])
//        let daily = Daily(day: Calendar.current.date(byAdding: .day, value: -1, to: Date())!, tasks: [
//            "Combine 스터디" : 4112,
//            "코테 그리디": 3447,
//            "세모문 개발": 6000,
//            "TiTi 개발": 5053
//        ], maxTime: 3012, timeline: [
//            0, 0, 0, 0, 0, 0, 0, 0, 0, 1000, 2800, 3600, 2320, 1800, 1200, 2800, 3600, 2820, 3430, 0, 0, 0, 2020, 3000
//        ])
        let daily = Daily()
        return daily
    }
    
    static func getDumyStringDays() -> [String] {
        var days: [String] = []
        days.append("2021.05.30")
        days.append("2021.06.11")
        days.append("2021.06.20")
        days.append("2021.06.22")
        days.append("2021.06.25")
        days.append("2021.06.28")
        return days
    }
    
    static func getDumyDays(_ stringDays: [String]) -> [Date] {
        var days: [Date] = []
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY.MM.dd"
        for day in stringDays {
            let tempDay: Date = formatter.date(from: day)!
            days.append(tempDay)
        }
        return days
    }
    
    static var getDummyMonthTime: Int {
        return 428390
    }
}
