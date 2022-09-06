//
//  MonthSmallVM.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2022/09/06.
//  Copyright © 2022 FDEE. All rights reserved.
//

import Foundation

final class MonthSmallVM: ObservableObject {
    @Published var totalTime: Int = 0
    @Published var maxTime: Int = 0
    @Published var colorIndex: Int = 1
    
    init() {
        self.updateColor()
    }
    
    func update(monthTime: MonthTime) {
        self.totalTime = monthTime.totalTime
        self.maxTime = monthTime.maxTime
        self.colorIndex = monthTime.colorIndex
    }
    
    func updateColor() {
        self.colorIndex = UserDefaultsManager.get(forKey: .startColor) as? Int ?? 1
    }
}
