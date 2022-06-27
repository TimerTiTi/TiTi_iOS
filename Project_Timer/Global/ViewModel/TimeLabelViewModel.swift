//
//  TimeLabelViewModel.swift
//  Project_Timer
//
//  Created by 최수정 on 2022/06/23.
//  Copyright © 2022 FDEE. All rights reserved.
//

import SwiftUI

class TimeLabelViewModel: ObservableObject  {
    var hourTensViewModel: SingleTimeLabelViewModel
    var hourUnitsViewModel: SingleTimeLabelViewModel
    var minuteTensViewModel: SingleTimeLabelViewModel
    var minuteUnitsViewModel: SingleTimeLabelViewModel
    var secondTensViewModel: SingleTimeLabelViewModel
    var secondUnitsViewModel: SingleTimeLabelViewModel
    
    private var showAnimation: Bool
    @Published var time: Int {
        didSet {
            let timeLabel = TimeLabel.toTimeLabel(time)
            hourTensViewModel.update(timeLabel.hourTens)
            hourUnitsViewModel.update(timeLabel.hourUnits)
            minuteTensViewModel.update(timeLabel.minuteTens)
            minuteUnitsViewModel.update(timeLabel.minuteUnits)
            secondTensViewModel.update(timeLabel.secondTens)
            secondUnitsViewModel.update(timeLabel.secondUnits)
        }
    }
    
    init(time: Int, showAnimation: Bool) {
        self.showAnimation = showAnimation
        self.time = time
        let timeLabel = TimeLabel.toTimeLabel(time)
        self.hourTensViewModel = SingleTimeLabelViewModel(val: timeLabel.hourTens, showAnimation: showAnimation)
        self.hourUnitsViewModel = SingleTimeLabelViewModel(val: timeLabel.hourUnits, showAnimation: showAnimation)
        self.minuteTensViewModel = SingleTimeLabelViewModel(val: timeLabel.minuteTens, showAnimation: showAnimation)
        self.minuteUnitsViewModel = SingleTimeLabelViewModel(val: timeLabel.minuteUnits, showAnimation: showAnimation)
        self.secondTensViewModel = SingleTimeLabelViewModel(val: timeLabel.secondTens, showAnimation: showAnimation)
        self.secondUnitsViewModel = SingleTimeLabelViewModel(val: timeLabel.secondUnits, showAnimation: showAnimation)
    }
    
    func updateTime(_ newTime: Int) {
        self.time = newTime
    }
}
