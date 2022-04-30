//
//  Dumy.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2021/06/19.
//  Copyright © 2021 FDEE. All rights reserved.
//

import Foundation
struct Dumy {
    func getTasks() -> [String:Int] {
        var dumy: [String:Int] = [:]
//        dumy.updateValue(9200, forKey: "프로그래밍 공부")
//        dumy.updateValue(4820, forKey: "전공수업 과제")
//        dumy.updateValue(2170, forKey: "프로젝트 토의")
//        dumy.updateValue(1500, forKey: "영문학 공부")
//        dumy.updateValue(700, forKey: "운동")
//        dumy.updateValue(607, forKey: "책읽기")

        dumy.updateValue(9200, forKey: "Swift Programming")
        dumy.updateValue(4820, forKey: "Study Algorithm")
        dumy.updateValue(2170, forKey: "Running")
        dumy.updateValue(1500, forKey: "Cycling")
        dumy.updateValue(700, forKey: "Reading Book")
        dumy.updateValue(607, forKey: "Learning Korean")
//        dumy.updateValue(2000, forKey: "Swift")
//        dumy.updateValue(3000, forKey: "Java")
//        dumy.updateValue(1200, forKey: "C++")
//        dumy.updateValue(2400, forKey: "Python")
//        dumy.updateValue(2800, forKey: "Algorithm")
        
//        dumy.updateValue(1000, forKey: "coding")
//        dumy.updateValue(800, forKey: "blog")
//        dumy.updateValue(2200, forKey: "design")
//        dumy.updateValue(2500, forKey: "develop")
//        dumy.updateValue(2600, forKey: "typing")
//        dumy.updateValue(3600, forKey: "TiTi develop")
        return dumy
    }
    
    func getTimelines() -> [Int] {
        let timeline = [3000,1800,0,0,0,0,0,0,0,1200,2000,3000,2600,1800,3000,3600,1000,0,500,2000,800,0,300,1200]
        return timeline
    }
    
    func get7Dailys() -> [daily] {
        var DailyDatas: [daily] = []
        DailyDatas.append(daily(id: 1, day: "7/9",
                                studyTime: Converter.translate2(input: "3:37:20"),
                                breakTime: Converter.translate2(input: "0:37:50")))
        DailyDatas.append(daily(id: 2, day: "7/10",
                                studyTime: Converter.translate2(input: "2:58:23"),
                                breakTime: Converter.translate2(input: "2:02:15")))
        DailyDatas.append(daily(id: 3, day: "7/11",
                                studyTime: Converter.translate2(input: "6:02:07"),
                                breakTime: Converter.translate2(input: "1:40:08")))
        DailyDatas.append(daily(id: 4, day: "7/12",
                                studyTime: Converter.translate2(input: "4:03:39"),
                                breakTime: Converter.translate2(input: "1:05:00")))
        DailyDatas.append(daily(id: 5, day: "7/13",
                                studyTime: Converter.translate2(input: "3:35:15"),
                                breakTime: Converter.translate2(input: "2:32:56")))
        DailyDatas.append(daily(id: 6, day: "7/14",
                                studyTime: Converter.translate2(input: "5:10:12"),
                                breakTime: Converter.translate2(input: "2:01:00")))
        DailyDatas.append(daily(id: 7, day: "7/15",
                                studyTime: Converter.translate2(input: "5:16:37"),
                                breakTime: Converter.translate2(input: "0:35:20")))
        return DailyDatas
    }
    
    func getDumyDaily() -> Daily {
        var daily: Daily = Daily()
//        daily.maxTime = 3730
//        daily.tasks = getTasks()
//        daily.timeline = getTimelines()
//        let formatter = DateFormatter()
//        formatter.dateFormat = "YYYY.MM.dd"
//        let tempDay: Date = formatter.date(from: "2021.07.15")!
//        daily.day = tempDay
        return daily
    }
    
    func getDumyStringDays() -> [String] {
        var days: [String] = []
        days.append("2021.05.30")
        days.append("2021.06.11")
        days.append("2021.06.20")
        days.append("2021.06.22")
        days.append("2021.06.25")
        days.append("2021.06.28")
        return days
    }
    
    func getDumyDays(_ stringDays: [String]) -> [Date] {
        var days: [Date] = []
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY.MM.dd"
        for day in stringDays {
            let tempDay: Date = formatter.date(from: day)!
            days.append(tempDay)
        }
        return days
    }
}

//        temp["Learning Korean"] = 2100
//        temp["Swift Programming"] = 4680
//        temp["Cycleing"] = 3900
//        temp["Running"] = 2700
//        temp["Reading Book"] = 2280
//        temp["프로그래밍 공부"] = 4680
//        temp["전공수업 과제"] = 3900
//        temp["프로젝트 토의"] = 2700
//        temp["책읽기"] = 2280
//        temp["영문학 공부"] = 2100
