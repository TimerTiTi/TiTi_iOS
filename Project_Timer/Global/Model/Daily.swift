//
//  Daily.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2021/04/06.
//  Copyright © 2021 FDEE. All rights reserved.
//

import Foundation

struct Daily: Codable, CustomStringConvertible {
    var description: String {
        return "\(self.day.YYYYMMDDstyleString)"
    }
    
    var day: Date = Date()
    var timeline = Array(repeating: 0, count: 24) //24시 : 0, 01시 : 1
    var tasks: [String: Int] = [:] // 과목명 : 누적시간
    var currentTask: String = "" // tasks 증가를 위한 key값
    var currentTaskFromTime: Int? = 0 // tasks 증가를 위한 기준값
    var maxTime: Int = 0 //최고연속시간
    var totalTime: Int { // computed property
        return self.tasks.values.reduce(0, +)
    }
    
    mutating func recordStartSetting(taskName: String) {
        self.currentTask = taskName
        self.currentTaskFromTime = self.tasks[self.currentTask] ?? 0
        self.save()
    }
    
    mutating func updateCurrentTaskTime(interval: Int) {
        self.tasks[self.currentTask] = self.currentTaskFromTime ?? 0 + interval // dictionary update
        self.timeline[Date().hour] += 1 // timeline update
    }
    
    mutating func updateMaxTime(with interval: Int) {
        self.maxTime = max(self.maxTime, interval)
    }
    
    mutating func reset(_ totalTime: Int, _ timerTime: Int) {
        self = Daily()
        self.save()
    }
    
    func save() {
        Storage.store(self, to: .documents, as: "daily.json")
    }
    
    mutating func load() {
        self = Storage.retrive("daily.json", from: .documents, as: Daily.self) ?? Daily()
    }
    
    mutating func updateCurrentTaskTimeOfBackground(startAt: Date, interval: Int) {
        self.tasks[self.currentTask] = self.currentTaskFromTime ?? 0 + interval
        
        let now = Date()
        let startHour = startAt.hour
        var nowHour = now.hour
        if nowHour < startHour { nowHour += 24 } // 현재시각이 백그라운드 진입 시각보다 작은 경우 : 00시를 지난 경우는 24를 더한다
        
        // 동일 시간대에 백그라운드 컴백 : interval 만큼 증가
        if startHour == nowHour {
            self.timeline[nowHour] += interval
            return
        }
        // 백그라운드 나간 시간대 : 3599 - (해당시각까지의 분+초) 값 반영
        self.timeline[startHour] += 3599 - self.getSecondsAt(startAt)
        // 백그라운드 그외 시간대 반영
        for h in startHour+1...nowHour {
            if h != nowHour {
                self.timeline[h%24] = 3600
            } else {
                self.timeline[h%24] += self.getSecondsAt(now)
            }
        }
    }
    
    private func getSecondsAt(_ date: Date) -> Int {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "mm"
        let M = Int(dateFormatter.string(from: date))! //분
        dateFormatter.dateFormat = "ss"
        let S = Int(dateFormatter.string(from: date))! //초
        return M*60+S
    }
}
