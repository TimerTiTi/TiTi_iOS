//
//  WeekTimelineVM.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2022/07/30.
//  Copyright © 2022 FDEE. All rights reserved.
//

import Foundation

final class WeekTimelineVM: ObservableObject {
    @Published var color1Index: Int = 2
    @Published var color2Index: Int = 1
    @Published var weekTimes: [WeekTimeBlock] = []
    
    init() {
        self.updateColor()
        self.resetTimes()
    }
    
    func update(weekData: WeekDailysData) {
        var weekTimes = self.weekTimes
        for idx in 0...6 {
            let day = weekData.weekDates[idx].MDstyleString
            if let daily = weekData.dailys[idx] {
                weekTimes[idx] = WeekTimeBlock(id: idx, day: day, sumTime: daily.totalTime)
            } else {
                weekTimes[idx] = WeekTimeBlock(id: idx, day: day, sumTime: 0)
            }
        }
        self.weekTimes = weekTimes
    }
    
    func updateColor() {
        let userColorIndex = UserDefaultsManager.get(forKey: .startColor) as? Int ?? 1
        let isReversColor = UserDefaultsManager.get(forKey: .reverseColor) as? Bool ?? false
        let offset = isReversColor ? -1 : 1
        let resultColorIndex = (userColorIndex+offset+12)%12
        
        self.color1Index = resultColorIndex == 0 ? 12 : resultColorIndex
        self.color2Index = userColorIndex
    }
    
    private func resetTimes() {
        self.weekTimes = (0...6).map { WeekTimeBlock(id: $0, day: "-/-", sumTime: 0) }
    }
}
