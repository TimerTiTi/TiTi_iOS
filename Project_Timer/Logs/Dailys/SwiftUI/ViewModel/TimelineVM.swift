//
//  TimelineVM.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2022/07/17.
//  Copyright © 2022 FDEE. All rights reserved.
//

import Foundation

final class TimelineVM: ObservableObject {
    @Published var color1Index: Int = 2
    @Published var color2Index: Int = 1
    @Published var times: [TimeBlock] = []
    
    init() {
        self.updateColor(isReversColor: false)
        self.resetTimes()
    }
    
    func update(daily: Daily?) {
        guard let timeline = daily?.timeline else {
            self.resetTimes()
            return
        }
        
        self.times = (5...28).map { index in
            TimeBlock(id: index%24, sumTime: timeline[index%24])
        }
    }
    
    func updateColor(isReversColor: Bool) {
        let userColorIndex = UserDefaultsManager.get(forKey: .startColor) as? Int ?? 1
        if isReversColor {
            self.color1Index = (userColorIndex-1+12)%12 == 0 ? 12 : (userColorIndex-1+12)%12
            self.color2Index = userColorIndex
        } else {
            self.color1Index = (userColorIndex+1+12)%12 == 0 ? 12 : (userColorIndex+1+12)%12
            self.color2Index = userColorIndex
        }
    }
    
    private func resetTimes() {
        self.times = (5...28).map { TimeBlock(id: $0%24, sumTime: 0) }
    }
}
