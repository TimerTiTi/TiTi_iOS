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
        print("load dailys!")
        print(dates)
        print(dailys)
    }
    
    func saveDailys() {
        Storage.store(dailys, to: .documents, as: "dailys.json")
        UserDefaults.standard.setValue(dates, forKey: "dates")
    }
    
    func addDaily(_ daily: Daily) {
        let day = ViewManager().changeDate(daily.day)
        if(!dates.contains(day)) {
            //새로운 데이터 추가이기에 추가 및 dates도 추가
            dailys.append(daily)
            dates.append(day)
            saveDailys()
            print("save daily!")
            print(dates)
            print(dailys)
        } else {
            //동일데이터가 있기에 마지막 데이터만 업데이트
            dailys.removeLast()
            dailys.append(daily)
            saveDailys()
            print("update daily!")
            print(dates)
            print(dailys)
        }
    }
}
