//
//  TargetTimePickerVM.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2022/10/07.
//  Copyright © 2022 FDEE. All rights reserved.
//

import Foundation

final class TargetTimePickerVM {
    private let key: UserDefaultsManager.Keys
    private(set) var items: [String] = []
    
    init(key: UserDefaultsManager.Keys) {
        self.key = key
        switch key {
        case .goalTimeOfDaily:
            // 1 ~ 24
            self.items = (1...24).map { "\($0) H" }
        case .goalTimeOfWeek:
            // 1 ~ 168
            self.items = (1...168).map { "\($0) H" }
        case .goalTimeOfMonth:
            // 1 ~ 720
            self.items = (1...720).map { "\($0) H" }
        default:
            return
        }
    }
    
    func updateValue(index: Int) {
        let selectedHour = (index+1)*3600
        UserDefaultsManager.set(to: selectedHour, forKey: self.key)
        
        if self.key == .goalTimeOfDaily {
            RecordController.shared.recordTimes.updateGoalTime(to: selectedHour)
        }
    }
}
