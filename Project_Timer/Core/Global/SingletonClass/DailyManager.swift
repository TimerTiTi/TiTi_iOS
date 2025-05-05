//
//  DailyManager.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2021/06/29.
//  Copyright © 2021 FDEE. All rights reserved.
//

import Foundation

final class DailyManager {
    static let dailysFileName: String = "dailys.json"
    var dailys: [Daily] = [] {
        didSet {
            self.dates = self.dailys.map({ $0.day.zeroDate })
        }
    }
    var dates: [Date] = []
    var currentDaily: Daily!
    
    init() {
        loadDailys()
        loadDaily()
    }
    
    private func loadDailys() {
        self.dailys = Storage.retrive(Self.dailysFileName, from: .documents, as: [Daily].self) ?? []
        // 비어 있으면 백업도 확인
        if dailys.isEmpty {
            self.dailys = Storage.retrive("tmp_\(Self.dailysFileName)", from: .documents, as: [Daily].self) ?? []
        }
        
        self.dates = self.dailys.map({ $0.day.zeroDate })
        print("load dailys!")
        
        // 위젯용 데이터 저장
        self.saveCalendarWidgetData()
    }
    
    private func loadDaily() {
        if let savedDaily = Storage.retrive(Daily.fileName, from: .documents, as: Daily.self) {
            currentDaily = savedDaily
        } else {
            currentDaily = Daily()
            currentDaily.save()
        }
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
        dailys = dailys.filter { $0.totalTime > 0 }
        self.saveDailys()
    }
    
    public func updateDaily(to daily: Daily) {
        currentDaily = daily
        currentDaily.save()
    }
}

extension DailyManager {
    func saveCalendarWidgetData() {
        let monthWidgetData = CalendarWidgetData(dailys: self.dailys)
        Storage.store(monthWidgetData, to: .sharedContainer, as: CalendarWidgetData.fileName)
        print("save CalendarWidgetData!")
    }
}
