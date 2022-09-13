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
    @Published var weekTimes: [WeekTimeBlock] = []
    @Published var totalTime: Int = 0
    @Published var averageTime: Int = 0
    @Published var color1Index: Int = 2
    @Published var color2Index: Int = 1
    
    init() {
        self.updateColor(isReverseColor: false)
        self.resetTimes()
    }
    
    func update(weekTime: WeekTime) {
        self.weekDates = weekTime.weekDates
        self.weekNum = weekTime.weekNum
        self.totalTime = weekTime.totalTime
        self.averageTime = weekTime.averageTime
        self.updateColor(isReverseColor: weekTime.reverseColor)
        
        var weekTimes = self.weekTimes
        for idx in 0...6 {
            let day = weekTime.weekDates[idx].MDstyleString
            if let daily = weekTime.dailys[idx] {
                weekTimes[idx] = WeekTimeBlock(id: idx, day: day, sumTime: daily.totalTime)
            } else {
                weekTimes[idx] = WeekTimeBlock(id: idx, day: day, sumTime: 0)
            }
        }
        self.weekTimes = weekTimes
    }

    func updateColor(isReverseColor: Bool) {
        let offset = isReverseColor ? -1 : 1
        let userColorIndex = UserDefaultsManager.get(forKey: .startColor) as? Int ?? 1
        let resultColorIndex = (userColorIndex+offset+12)%12

        self.color1Index = resultColorIndex == 0 ? 12 : resultColorIndex
        self.color2Index = userColorIndex
    }
    
    private func resetTimes() {
        self.weekTimes = (0...6).map { WeekTimeBlock(id: $0, day: "-/-", sumTime: 0) }
    }
}
