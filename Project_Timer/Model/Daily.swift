//
//  Daily.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2021/04/06.
//  Copyright © 2021 FDEE. All rights reserved.
//

import UIKit
struct Daily: Codable {
    var day: Date = Date()
    var fixedTotalTime: Int = 0
    var fixedSumTime: Int = 0
    var fixedTimerTime: Int = 0
    var currentTotalTime: Int = 0
    var currentSumTime: Int = 0
    var currentTimerTime: Int = 0
    var breakTime: Int = 0
    var maxTime: Int = 0
    
    var startTime: Date = Date()
    var currentTask: String = ""
    var tasks: [String:Int] = [:]
    
    var beforeTime: Int = 0
    var timeline = Array(repeating: 0, count: 24)
    //24시 : 0, 01시 : 1
    
    mutating func startTask(_ task: String) {
        self.currentTask = task
        self.startTime = Date()
        self.beforeTime = tasks[currentTask] ?? 0
    }
    
    mutating func stopTask() {
        var value = tasks[currentTask] ?? 0
        value += getSeconds()
        tasks[currentTask] = value
    }
    
    mutating func updateTask(_ seconds: Int) {
        tasks[currentTask] = beforeTime+seconds
        //현재 시간에 따른 값을 증가
        let H: Int = getHour(Date())
        timeline[H] += 1
        self.save()
    }
    
    mutating func reset() {
        self = Daily()
        save()
    }
    
    func getSeconds() -> Int {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.hour, .minute, .second], from: self.startTime, to: Date())
        let result = components.hour!*3600 + components.minute!*60 + components.second!
        return result
    }
    
    func save() {
        Storage.store(self, to: .documents, as: "daily.json")
    }
    
    mutating func load() {
        self = Storage.retrive("daily.json", from: .documents, as: Daily.self) ?? Daily()
    }
    
    mutating func addHoursInBackground(_ start: Date, _ term: Int) {
        let H: Int = getHour(Date())
        timeline[H] -= 1
        
        let now = Date()
        let startH = getHour(start)
        let nowH = getHour(now)
        //동일 시간대에 백그라운드 컴백 : term 만큼 증가
        if(startH == nowH) {
            timeline[nowH] += term
        }
        //시간대가 달라진 경우 : 해당 시간대에 시간 저장
        else {
            //백그라운드 나간 시간대
            timeline[startH] += 3599 - getSeconds(start)
            
            for h in startH+1...nowH {
                //종료 시간대가 아닌 경우 : 1시간 채우기
                if(h != nowH) {
                    timeline[h] += 3600
                }
                //종료 시간대인 경우 : 현재 시간의 초만큼 채우기
                else {
                    timeline[h] += getSeconds(now)
                }
            }
        }
    }
    
    func getHour(_ date: Date) -> Int {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH"
        return Int(dateFormatter.string(from: date))! //시간
    }
    
    func getSeconds(_ date: Date) -> Int {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "mm"
        let M = Int(dateFormatter.string(from: date))! //분
        dateFormatter.dateFormat = "ss"
        let S = Int(dateFormatter.string(from: date))! //초
        return M*60+S
    }
}
