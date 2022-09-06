//
//  WeekSmallVM.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2022/09/06.
//  Copyright © 2022 FDEE. All rights reserved.
//

import Foundation

final class WeekSmallVM: ObservableObject {
    @Published var totalTime: Int = 0
    @Published var maxTime: Int = 0
    @Published var colorIndex: Int = 1
    
    init() {
        self.updateColor()
    }
    
    func update(weekSmallTime: WeekSmallTime) {
        self.totalTime = weekSmallTime.totalTime
        self.maxTime = weekSmallTime.maxTime
        self.colorIndex = weekSmallTime.colorIndex
    }
    
    func updateColor() {
        self.colorIndex = UserDefaultsManager.get(forKey: .startColor) as? Int ?? 1
    }
}
