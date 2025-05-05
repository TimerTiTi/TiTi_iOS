//
//  Daily.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2021/04/06.
//  Copyright © 2021 FDEE. All rights reserved.
//

import Foundation

struct Daily: Codable {
    enum Status: String {
        case uploaded
        case created
        case edited
    }
    
    static let fileName: String = "daily.json"
    private(set) var day: Date // 기록 날짜값
    private(set) var tasks: [String: Int] = [:] // 과목명-누적시간 값
    private(set) var maxTime: Int = 0 // 최고 연속시간
    private(set) var timeline = Array(repeating: 0, count: 24) // 시간대별 그래프값, (24시: 0)
    var totalTime: Int { // computed property
        return self.tasks.values.reduce(0, +)
    }
    private(set) var taskHistorys: [String: [TaskHistory]]? = [:]
    private(set) var id: Int? // server pk
    private(set) var status: String? // server 반영여부
    
    /// Create
    init() {
        let now = Date()
        let dayHour = RecordsManager.resetHour
        
        if now.hour < dayHour {
            self.day = now.nextDay(offset: -1).setTime(hour: dayHour)
        } else {
            self.day = now.setTime(hour: dayHour)
        }
        
        print("Daily(\(self.day.YYYYMMDDHMSstyleString)) init")
    }
    /// Modify
    init(newDate: Date) {
        self.day = newDate.setTime(hour: RecordsManager.resetHour, minute: 0, second: 0)
    }
    
    /// SyncDaily
    init(id: Int?, status: String?, day: Date, timeline: [Int],
         maxTime: Int, tasks: [String: Int], taskHistorys: [String: [TaskHistory]]?) {
        self.id = id
        self.status = status
        self.day = day
        self.timeline = timeline
        self.maxTime = maxTime
        self.tasks = tasks
        self.taskHistorys = taskHistorys
    }
    
    // 10간격, 또는 종료시 update 반영
    mutating func update(at current: Date) {
        let recordTimes = RecordsManager.shared.recordTimes
        // 기존 과거형식의 기록, 또는 기록중인 상태의 경우 -> 기존 update 로직을 통해 Daily 값을 update 한다
        if self.taskHistorys == nil {
            let interval = Date.interval(from: recordTimes.recordStartAt, to: current)
            self.tasks[recordTimes.recordTask] = recordTimes.recordTaskFromTime + interval
            self.maxTime = max(self.maxTime, interval)
            self.updateTimeline(recordTimes: recordTimes, interval: interval, current: current)
        }
        // 업데이트 후 새로운 기록 이후 taskHistorys 가 nil 값이 아닌 상태의 경우 -> taskHistorys 를 기반으로 Daily 값을 update 한다
        else {
            self.updateTaskHistorys(taskName: recordTimes.recordTask, startDate: recordTimes.recordStartAt, endDate: current)
            self.updateTasks()
            self.updateMaxTime()
            self.updateTimeline()
        }
        // backend 와 연동 후 uploaded 상태인 경우 edited 로 변경
        if status == "uploaded" {
            self.setEdited()
        }
        self.save()
    }
    
    mutating func setEdited() {
        self.status = "edited"
    }
    
    private mutating func updateTimeline(recordTimes: RecordTimes, interval: Int, current endDate: Date) {
        let startDate = recordTimes.recordStartAt
        
        let startHour = startDate.hour
        let endHour = startHour + (interval + startDate.seconds)/3600
        
        // 동일 시간대: interval 만큼 증가
        if startHour == endHour {
            self.timeline[endHour] = min(3600, recordTimes.recordStartTimeline[endHour] + interval)
            self.save()
            return
        }
        
        self.timeline[startHour] = min(3600, recordTimes.recordStartTimeline[startHour] + (3600 - recordTimes.recordStartAt.seconds))
        self.timeline[startHour] = min(3600, self.timeline[startHour])
        
        for h in startHour+1...endHour {
            if h != endHour {
                self.timeline[h%24] = 3600
            } else {
                self.timeline[h%24] = min(3600, endDate.seconds)
            }
        }
    }
    // 기존 tasks 정보 수정시
    mutating func updateTasks(to newTasks: [String: Int]) {
        self.tasks = newTasks
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
}

// MARK: 새로운 기록저장 로직
extension Daily {
    private mutating func updateTaskHistorys(taskName: String, startDate: Date, endDate: Date) {
        if var taskHistorys = self.taskHistorys {
            if taskHistorys[taskName] == nil {  // 과목 기록이 없었던 경우
                taskHistorys[taskName] = []     // 빈 배열로 초기화
            }
            taskHistorys[taskName]?.append(TaskHistory(startDate: startDate, endDate: endDate))
            // TODO: sort 로직 수정 필요 새벽 5시~새벽4시
            taskHistorys[taskName]?.sort(by: { $0.startDate < $1.startDate })
            self.taskHistorys = taskHistorys
        } else {
            assertionFailure("taskHistorys 값이 nil 입니다.")
        }
    }
    
    private mutating func updateTasks() {
        guard let taskHistorys = self.taskHistorys else { return }
        var tasks: [String: Int] = [:]
        taskHistorys.forEach { task, historys in
            tasks[task] = historys.map { $0.interval }.reduce(0, +)
        }
        self.tasks = tasks
    }
    
    private mutating func updateMaxTime() {
        guard let taskHistorys = self.taskHistorys else { return }
        var maxTime: Int = 0
        taskHistorys.forEach { task, historys in
            if historys.isEmpty == false {
                maxTime = max(maxTime, historys.map { $0.interval }.max()!)
            }
        }
        self.maxTime = maxTime
    }
    
    private mutating func updateTimeline() {
        guard let taskHistorys = self.taskHistorys else { return }
        
        var timeline = Array(repeating: 0, count: 24)
        taskHistorys.forEach { _, historys in
            historys.forEach { history in
                let startHour = history.startDate.hour
                let endHour = startHour + (history.interval + history.startDate.seconds)/3600
                
                // MARK: 동시간대의 기록
                if startHour == endHour {
                    timeline[startHour%24] += history.interval
                } 
                // MARK: 시간대가 다른 경우: hour%24 위치에 block 추가
                else {
                    timeline[startHour%24] += (3600 - history.startDate.seconds)
                    for h in startHour+1..<endHour {
                        timeline[h%24] = 3600
                    }
                    timeline[endHour%24] += history.endDate.seconds
                }
            }
        }
        for i in 0...23 { timeline[i] = min(3600, timeline[i]) }
        self.timeline = timeline
    }
}

// MARK: ModifyRecordVM 내에서 불리는 메소드들
extension Daily {
    mutating func changeTaskName(from oldName: String, to newName: String) {
        // 같은 이름의 과목이 없다는 것이 보장된 상태
        
        // tasks 업데이트
        let totalTime = self.tasks[oldName]
        self.tasks.removeValue(forKey: oldName)
        self.tasks[newName] = totalTime
        
        // taskHistorys 업데이트
        let historys = self.taskHistorys?[oldName]
        self.taskHistorys?.removeValue(forKey: oldName)
        self.taskHistorys?[newName] = historys
    }
    
    mutating func updateTaskHistorys(of taskName: String, with historys: [TaskHistory]) {
        if historys.isEmpty {
            self.taskHistorys?[taskName] = nil
        } else {
            self.taskHistorys?[taskName] = historys
        }
        
        self.updateTasks()
        self.updateMaxTime()
        self.updateTimeline()
    }
}

// MARK: Preview용
extension Daily {
    
    /// Preview
    init(day: Date,taskHistorys: [String: [TaskHistory]]) {
        self.day = day.setTime(hour: RecordsManager.resetHour, minute: 0, second: 0)
        self.taskHistorys = taskHistorys
        self.updateTasks()
        self.updateMaxTime()
        self.updateTimeline()
    }
    
    static var testInfo: Daily {
        let startDate = Date().zeroDate
        let endDate = Calendar.current.date(byAdding: .hour, value: 23, to: startDate)!
        let taskHistorys: [String: [TaskHistory]] = [
            "Task1": [
                TaskHistory(startDate: startDate, endDate: Calendar.current.date(byAdding: .second, value: 4000, to: startDate)!)
            ],
            "테스트": [
                TaskHistory(startDate: Calendar.current.date(byAdding: .hour, value: 2, to: startDate)!, endDate: Calendar.current.date(byAdding: .hour, value: 3, to: startDate)!)
            ],
            "选择 Task 修改记录后\n请按 SAVE": [
                TaskHistory(startDate: Calendar.current.date(byAdding: .hour, value: 3, to: startDate)!, endDate: endDate)
            ]
        ]
        return .init(day: Date(), taskHistorys: taskHistorys)
    }
}
