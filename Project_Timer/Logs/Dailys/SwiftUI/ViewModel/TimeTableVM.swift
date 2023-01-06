//
//  TimeTableVM.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2023/01/06.
//  Copyright © 2023 FDEE. All rights reserved.
//

import Foundation

final class TimeTableVM: ObservableObject {
    @Published var blocks: [TimeTableBlock] = []
    
    init() {
        self.updateColor()
    }
    
    func update(daily: Daily?) {
        guard let taskHistorys = daily?.taskHistorys else {
            self.blocks = []
            return
        }
        // taskHistorys -> TimeTableBlock 생성 필요
    }
    
    func updateColor() {
        let userColorIndex = UserDefaultsManager.get(forKey: .startColor) as? Int ?? 1
        let isReversColor = UserDefaultsManager.get(forKey: .reverseColor) as? Bool ?? false
        if isReversColor {
            
        } else {
            
        }
    }
}
