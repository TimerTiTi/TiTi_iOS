//
//  StopwatchVM.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2022/04/29.
//  Copyright © 2022 FDEE. All rights reserved.
//

import Foundation
import Combine

final class StopwatchVM {
    @Published private(set) var times: Times
    @Published private(set) var daily: Daily
    @Published private(set) var runningUI = false
    private(set) var timerRunning = false
    
    private var timer = Timer()
    
    init() {
        self.times = RecordController.shared.recordTimes.currentTimes()
        self.daily = RecordController.shared.daily
        self.timerRunning = RecordController.shared.recordTimes.recording
        self.runningUI = self.timerRunning
        
        if self.timerRunning {
            self.timerStart()
        }
    }
    
    func timerStart() {
        
    }
    
    func timerStop() {
        
    }
    
    func updateModeNum() {
        UserDefaultsManager.set(to: 2, forKey: .VCNum)
        RecordController.shared.recordTimes.updateMode(to: 2)
    }
    
    var task: String {
        return RecordController.shared.recordTimes.recordTask
    }
    
    func updateTimes() {
        self.times = RecordController.shared.recordTimes.currentTimes()
    }
    
    func updateDaily() {
        self.daily = RecordController.shared.daily
    }
}
