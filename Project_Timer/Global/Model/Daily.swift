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
        return "\(self.day.YYYYMMDDstyleString) : \(self.tasks)"
    }
    static let fileName: String = "daily.json"
    private(set) var day: Date = Date() // 기록 날짜값
    private(set) var tasks: [String: Int] = [:] // 과목명-누적시간 값
    private(set) var maxTime: Int = 0 // 최고 연속시간
    private(set) var timeline = Array(repeating: 0, count: 24) // 시간대별 그래프값, (24시: 0)
    var totalTime: Int { // computed property
        return self.tasks.values.reduce(0, +)
    }
    
    // 10간격, 또는 종료시 update 반영
    mutating func update(at current: Date) {
        let recordTimes = RecordController.shared.recordTimes
        let interval = recordTimes.interval(to: current)
        self.tasks[recordTimes.recordTask] = recordTimes.recordTaskFromTime + interval
        self.maxTime = max(self.maxTime, interval)
        self.updateTimeline(recordTimes: recordTimes, interval: interval, current: current)
        self.save()
    }
    
    private mutating func updateTimeline(recordTimes: RecordTimes, interval: Int, current: Date) {
        let startHour = recordTimes.recordStartAt.hour
        let nowHour = current.hour < startHour ? current.hour+24 : current.hour
        // 동일 시간대: interval 만큼 증가
        if startHour == nowHour {
            self.timeline[nowHour] = recordTimes.recordStartTimeline[nowHour] + interval
            self.save()
            return
        }
        
        self.timeline[startHour] = 3600
        for h in startHour+1...nowHour {
            if h != nowHour {
                self.timeline[h%24] = 3600
            } else {
                self.timeline[h%24] = self.getSecondsAt(current)
            }
        }
        self.save()
    }
    
    // 새로운 날짜의 기록 시작시 reset
    mutating func reset() {
        self = Daily()
        self.save()
    }
    
    func save() {
        Storage.store(self, to: .documents, as: Daily.fileName)
    }
    
    mutating func load() {
        self = Storage.retrive(Daily.fileName, from: .documents, as: Daily.self) ?? Daily()
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
