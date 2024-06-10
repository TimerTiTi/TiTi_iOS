//
//  DailyManager.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2021/06/29.
//  Copyright © 2021 FDEE. All rights reserved.
//

import Foundation

final class DailyManager {
    static let shared = DailyManager()
    static let dailysFileName: String = "dailys.json"
    var dailys: [Daily] = [] {
        didSet {
            self.dates = self.dailys.map({ $0.day.zeroDate })
        }
    }
    var dates: [Date] = []
    
    private init() {}
    
    func loadDailys() {
        self.dailys = Storage.retrive(Self.dailysFileName, from: .documents, as: [Daily].self) ?? []
        self.dates = self.dailys.map({ $0.day.zeroDate })
        print("load dailys!")
        
        // 위젯용 데이터 저장
        self.saveCalendarWidgetData()
    }
    
    func saveDailys() {
        Storage.store(dailys, to: .documents, as: Self.dailysFileName)
        print("store dailys!")
        
        // 위젯용 데이터 저장
        self.saveCalendarWidgetData()
    }
    
    func addDaily(_ daily: Daily) {
        self.dailys.removeAll(where: { $0.day.zeroDate == daily.day.zeroDate })
        self.dailys.append(daily)
        self.dailys.sort(by: { $0.day < $1.day })
        self.saveDailys()
    }

    func modifyDaily(_ newDaily: Daily) {
        if let index = self.dailys.firstIndex(where: { $0.day == newDaily.day }) {
            if newDaily.totalTime == 0 {
                self.dailys.remove(at: index)
            } else {
                self.dailys[index] = newDaily
            }
        } else if newDaily.totalTime > 0 {
            self.dailys.append(newDaily)
            self.dailys.sort(by: { $0.day < $1.day })
        }
        self.saveDailys()
    }
    
    func changeDailys(to serverDailys: [Daily]) {
        self.dailys = serverDailys
        self.dailys.sort(by: { $0.day < $1.day })
        self.saveDailys()
    }
    
    func removeEmptyDailys() {
        dailys = dailys.filter { daily in
            return daily.totalTime > 0
        }
        self.saveDailys()
    }
}

extension DailyManager {
    func saveCalendarWidgetData() {
        let monthWidgetData = CalendarWidgetData(dailys: self.dailys)
        Storage.store(monthWidgetData, to: .sharedContainer, as: CalendarWidgetData.fileName)
        print("save CalendarWidgetData!")
    }
}
