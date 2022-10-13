//
//  TimerTimeLabelVM.swift
//  Project_Timer
//
//  Created by 최수정 on 2022/06/27.
//  Copyright © 2022 FDEE. All rights reserved.
//

import SwiftUI

class TimerTimeLabelVM: ObservableObject {
    enum TimerState {
        case normalRunning
        case lessThan60Sec
        case stopped
    }
    @Published var timeLabelVM: BaseTimeLabelVM
    @Published var time: Int
    
    var finished: Bool {
        self.time == 0
    }
    
    var timerState: TimerState {
        if timeLabelVM.isRunning {
            return self.time < 60 ? .lessThan60Sec : .normalRunning
        } else {
            return .stopped
        }
    }
    
    init(time: Int, fontSize: CGFloat, isWhite: Bool) {
        self.time = time
        self.timeLabelVM = BaseTimeLabelVM(time: abs(time), fontSize: fontSize, isWhite: isWhite)
    }
    
    func updateTime(_ newTime: Int, showsAnimation: Bool) {
        self.time = newTime
        self.timeLabelVM.updateTime(abs(newTime), showsAnimation: showsAnimation)
    }
    
    func updateRunning(to isRunning: Bool) {
        self.timeLabelVM.isRunning = isRunning
    }
    
    func updateIsWhite(to isWhite: Bool) {
        self.timeLabelVM.isWhite = isWhite
    }
}
