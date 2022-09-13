//
//  WeekVM.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2022/09/13.
//  Copyright © 2022 FDEE. All rights reserved.
//

import Foundation

final class WeekVM: ObservableObject {
    @Published var weekDates: [Date] = []
    @Published var weekNum: Int = 1
    @Published var dailys: [Daily?] = Array(repeating: nil, count: 7)
    @Published var totalTime: Int = 0
    @Published var averageTime: Int = 0
    @Published var color1Index: Int = 2
    @Published var color2Index: Int = 1
    
    init() {
        self.updateColor(isReverseColor: false)
    }
    
    func update(weekTime: WeekTime) {
        self.weekDates = weekTime.weekDates
        self.weekNum = weekTime.weekNum
        self.dailys = weekTime.dailys
        self.totalTime = weekTime.totalTime
        self.averageTime = weekTime.averageTime
        self.updateColor(isReverseColor: weekTime.reverseColor)
    }

    func updateColor(isReverseColor: Bool) {
        let offset = isReverseColor ? -1 : 1
        let userColorIndex = UserDefaultsManager.get(forKey: .startColor) as? Int ?? 1
        let resultColorIndex = (userColorIndex+offset+12)%12

        self.color1Index = resultColorIndex == 0 ? 12 : resultColorIndex
        self.color2Index = userColorIndex
    }
}
