//
//  TimeLabelViewModel.swift
//  Project_Timer
//
//  Created by 최수정 on 2022/06/23.
//  Copyright © 2022 FDEE. All rights reserved.
//

import SwiftUI

class TimeLabelViewModel: ObservableObject  {
    @Published var time: Int
    var hourTensViewModel: SingleTimeLabelViewModel
    var hourUnitsViewModel: SingleTimeLabelViewModel
    var minuteTensViewModel: SingleTimeLabelViewModel
    var minuteUnitsViewModel: SingleTimeLabelViewModel
    var secondTensViewModel: SingleTimeLabelViewModel
    var secondUnitsViewModel: SingleTimeLabelViewModel
    
    var timeLabel: TimeLabel {
        return TimeLabel(self.time)
    }
    
    init(time: Int) {
        self.time = time
        let timeLabel = TimeLabel(time)
        self.hourTensViewModel = SingleTimeLabelViewModel(timeLabel.hourTens)
        self.hourUnitsViewModel = SingleTimeLabelViewModel(timeLabel.hourUnits)
        self.minuteTensViewModel = SingleTimeLabelViewModel(timeLabel.minuteTens)
        self.minuteUnitsViewModel = SingleTimeLabelViewModel(timeLabel.minuteUnits)
        self.secondTensViewModel = SingleTimeLabelViewModel(timeLabel.secondTens)
        self.secondUnitsViewModel = SingleTimeLabelViewModel(timeLabel.secondUnits)
    }
    
    func updateTime(_ newTime: Int, showsAnimation: Bool) {
        let newTimeLabel = TimeLabel(newTime)
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
