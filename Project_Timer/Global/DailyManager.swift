//
//  DailyManager.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2021/06/29.
//  Copyright © 2021 FDEE. All rights reserved.
//

import Foundation

class DailyManager {
    static let shared = DailyManager()
    var dailys: [Daily] = []
    var dates: [Date] = []
    
    func loadDailys() {
        dailys = Storage.retrive("dailys.json", from: .documents, as: [Daily].self) ?? []
        dates = UserDefaults.standard.value(forKey: "dates") as? [Date] ?? []
        
        // 최초 저장
        if !(UserDefaultsManager.get(forKey: .didSaveToSharedContainerBefore) as? Bool ?? false) {
            Storage.store(Log(dailys: dailys), to: .sharedContainer, as: Log.fileName)
            UserDefaultsManager.set(to: true, forKey: .didSaveToSharedContainerBefore)
        }
        print("load dailys!")
    }
    
    func saveDailys() {
        print("store dailys!")
        Storage.store(dailys, to: .documents, as: "dailys.json")
        // 위젯 표시를 위해 sharedContainer에 Log 형태로 저장
        Storage.store(Log(dailys: dailys), to: .sharedContainer, as: Log.fileName)
        UserDefaults.standard.setValue(dates, forKey: "dates")
    }
    
    func addDaily(_ daily: Daily) {
        let day = self.changeDate(daily.day)
        if(!dates.contains(day)) {
            //새로운 데이터 추가이기에 추가 및 dates도 추가
            dailys.append(daily)
            dates.append(day)
            saveDailys()
            print("save daily!")
        } else {
            //동일데이터가 있기에 마지막 데이터만 업데이트
            dailys.removeLast()
            dailys.append(daily)
            saveDailys()
            print("update daily!")
        }
    }
    
    private func changeDate(_ day: Date) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY.MM.dd"
        let beforeDay = dateFormatter.string(from: day)
        
        let afterDay: Date = dateFormatter.date(from: beforeDay)!
        return afterDay
    }
}
