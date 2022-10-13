//
//  TimeOfTimerViewModel.swift
//  Project_Timer
//
//  Created by 최수정 on 2022/06/27.
//  Copyright © 2022 FDEE. All rights reserved.
//

import SwiftUI

class TimeOfTimerViewModel: ObservableObject {
    enum TimerState {
        case normalRunning
        case lessThan60Sec
        case stopped
    }
    var timeLabelViewModel: BaseTimeLabelVM
    var fontSize: CGFloat
    @Published var time: Int
    @Published var isWhite: Bool = true
    
    var finished: Bool {
        self.time == 0
    }
    
    var timerState: TimerState {
        if timeLabelViewModel.isRunning {
            return self.time < 60 ? .lessThan60Sec : .normalRunning
        } else {
            return .stopped
        }
    }
    
    init(time: Int, fontSize: CGFloat, isWhite: Bool) {
        self.time = time
        self.isWhite = isWhite
        self.fontSize = fontSize
        self.timeLabelViewModel = BaseTimeLabelVM(time: abs(time), fontSize: fontSize, isWhite: isWhite)
    }
    
    func updateTime(_ newTime: Int, showsAnimation: Bool) {
        self.time = newTime
        self.timeLabelViewModel.updateTime(abs(newTime), showsAnimation: showsAnimation)
    }
    
    func updateRunning(to isRunning: Bool) {
        self.timeLabelViewModel.isRunning = isRunning
    }
    
    func updateIsWhite(to isWhite: Bool) {
        self.isWhite = isWhite
        self.timeLabelViewModel.isWhite = isWhite
    }
}
