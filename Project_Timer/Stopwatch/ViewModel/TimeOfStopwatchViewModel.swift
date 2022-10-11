//
//  TimeOfStopwatchViewModel.swift
//  Project_Timer
//
//  Created by 최수정 on 2022/06/27.
//  Copyright © 2022 FDEE. All rights reserved.
//

import SwiftUI

class TimeOfStopwatchViewModel: ObservableObject {
    var timeLabelViewModel: TimeLabelViewModel
    @Published var isRunning: Bool = false
    
    init(time: Int) {
        self.timeLabelViewModel = TimeLabelViewModel(time: time, fontSize: 70, isWhite: true)
    }
    
    func updateTime(_ newTime: Int, showsAnimation: Bool) {
        self.timeLabelViewModel.updateTime(newTime, showsAnimation: showsAnimation)
    }
}
