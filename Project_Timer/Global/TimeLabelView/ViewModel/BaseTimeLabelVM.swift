//
//  BaseTimeLabelVM.swift
//  Project_Timer
//
//  Created by 최수정 on 2022/06/23.
//  Copyright © 2022 FDEE. All rights reserved.
//

import SwiftUI

class BaseTimeLabelVM: ObservableObject  {
    @Published var time: Int
    @Published var isRunning: Bool = false
    @Published var isWhite: Bool = true
    let fontSize: CGFloat
    var hourTensViewModel: BaseSingleTimeLabelVM
    var hourUnitsViewModel: BaseSingleTimeLabelVM
    var minuteTensViewModel: BaseSingleTimeLabelVM
    var minuteUnitsViewModel: BaseSingleTimeLabelVM
    var secondTensViewModel: BaseSingleTimeLabelVM
    var secondUnitsViewModel: BaseSingleTimeLabelVM
    
    var timeLabel: TimeLabel {
        return TimeLabel(self.time, false)
    }
    
    init(time: Int, fontSize: CGFloat, isWhite: Bool) {
        self.time = time
        self.fontSize = fontSize
        self.isWhite = isWhite
        let timeLabel = TimeLabel(time, false)
        self.hourTensViewModel = BaseSingleTimeLabelVM(timeLabel.hourTens)
        self.hourUnitsViewModel = BaseSingleTimeLabelVM(timeLabel.hourUnits)
        self.minuteTensViewModel = BaseSingleTimeLabelVM(timeLabel.minuteTens)
        self.minuteUnitsViewModel = BaseSingleTimeLabelVM(timeLabel.minuteUnits)
        self.secondTensViewModel = BaseSingleTimeLabelVM(timeLabel.secondTens)
        self.secondUnitsViewModel = BaseSingleTimeLabelVM(timeLabel.secondUnits)
    }
    
    func updateTime(_ newTime: Int, showsAnimation: Bool, darkerMode: Bool) {
        let newTimeLabel = TimeLabel(newTime, darkerMode)
        hourTensViewModel.update(old: self.timeLabel.hourTens,
                                 new: newTimeLabel.hourTens,
                                 showsAnimation: showsAnimation)
        hourUnitsViewModel.update(old: self.timeLabel.hourUnits,
                                  new: newTimeLabel.hourUnits,
                                  showsAnimation: showsAnimation)
        minuteTensViewModel.update(old: self.timeLabel.minuteTens,
                                   new: newTimeLabel.minuteTens,
                                   showsAnimation: showsAnimation)
        minuteUnitsViewModel.update(old: self.timeLabel.minuteUnits,
                                    new: newTimeLabel.minuteUnits,
                                    showsAnimation: showsAnimation)
        secondTensViewModel.update(old: self.timeLabel.secondTens,
                                   new: newTimeLabel.secondTens,
                                   showsAnimation: showsAnimation)
        secondUnitsViewModel.update(old: self.timeLabel.secondUnits,
                                    new: newTimeLabel.secondUnits,
                                    showsAnimation: showsAnimation)
        self.time = newTime
    }
}
