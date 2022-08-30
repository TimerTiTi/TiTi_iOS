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
    var dailys: [Daily] = []
    var dates: [Date] {
        return dailys.map({ $0.day.zeroDate })
    }
    
    func loadDailys() {
        self.dailys = Storage.retrive(Self.dailysFileName, from: .documents, as: [Daily].self) ?? []
        print("load dailys!")
    }
    
    func saveDailys() {
        Storage.store(dailys, to: .documents, as: Self.dailysFileName)
        print("store dailys!")
    }
    
    func addDaily(_ daily: Daily) {
        self.dailys.removeAll(where: { $0.day.zeroDate == daily.day.zeroDate })
        self.dailys.append(daily)
        self.dailys.sort(by: { $0.day < $1.day })
        self.saveDailys()
    }

    func modifyDaily(_ newDaily: Daily) {
        guard let index = self.dailys.firstIndex(where: { $0.day == newDaily.day }) else { return }
        self.dailys[index] = newDaily
        self.saveDailys()
    }
}
