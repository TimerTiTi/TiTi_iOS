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
    
    func loadDailys() {
        self.dailys = Storage.retrive(Self.dailysFileName, from: .documents, as: [Daily].self) ?? []
        self.dates = self.dailys.map({ $0.day.zeroDate })
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
        if let index = self.dailys.firstIndex(where: { $0.day == newDaily.day }) {
            self.dailys[index] = newDaily
        } else {
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
}
