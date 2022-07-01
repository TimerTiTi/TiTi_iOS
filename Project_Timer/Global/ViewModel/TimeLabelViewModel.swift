//
//  TimeLabelViewModel.swift
//  Project_Timer
//
//  Created by 최수정 on 2022/06/23.
//  Copyright © 2022 FDEE. All rights reserved.
//

import SwiftUI

class TimeLabelViewModel: ObservableObject  {
    enum UpdateType {
        case countDown
        case countUp
        
        func tensOldValue(_ newValue: Int) -> Int {
            switch self {
            case .countDown:
                return newValue == 5 ? 0 : (newValue + 1)
            case .countUp:
                return newValue == 0 ? 5 : (newValue - 1)
            }
        }
        
        func unitsOldValue(_ newValue: Int) -> Int {
            switch self {
            case .countDown:
                return newValue == 9 ? 0 : (newValue + 1)
            case .countUp:
                return newValue == 0 ? 9 : (newValue - 1)
            }
        }
    }
    
    @Published var time: Int
    private var updateType: UpdateType
    var hourTensViewModel: SingleTimeLabelViewModel
    var hourUnitsViewModel: SingleTimeLabelViewModel
    var minuteTensViewModel: SingleTimeLabelViewModel
    var minuteUnitsViewModel: SingleTimeLabelViewModel
    var secondTensViewModel: SingleTimeLabelViewModel
    var secondUnitsViewModel: SingleTimeLabelViewModel
    
    var timeLabel: TimeLabel {
        return TimeLabel(self.time)
    }
    
    init(time: Int, updateType: UpdateType) {
        self.time = time
        self.updateType = updateType
        let timeLabel = TimeLabel(time)
        self.hourTensViewModel = SingleTimeLabelViewModel(old: updateType.tensOldValue(timeLabel.hourTens),
                                                          new: timeLabel.hourTens)
        self.hourUnitsViewModel = SingleTimeLabelViewModel(old: updateType.unitsOldValue(timeLabel.hourUnits),
                                                           new: timeLabel.hourUnits)
        self.minuteTensViewModel = SingleTimeLabelViewModel(old: updateType.tensOldValue(timeLabel.minuteTens),
                                                            new: timeLabel.minuteTens)
        self.minuteUnitsViewModel = SingleTimeLabelViewModel(old: updateType.unitsOldValue(timeLabel.minuteUnits),
                                                             new: timeLabel.minuteUnits)
        self.secondTensViewModel = SingleTimeLabelViewModel(old: updateType.tensOldValue(timeLabel.secondTens),
                                                            new: timeLabel.secondTens)
        self.secondUnitsViewModel = SingleTimeLabelViewModel(old: updateType.unitsOldValue(timeLabel.secondUnits),
                                                             new: timeLabel.secondUnits)
    }
    
    func updateTime(_ newTime: Int, showsAnimation: Bool) {
        self.time = newTime
        hourTensViewModel.update(old: updateType.tensOldValue(timeLabel.hourTens),
                                 new: timeLabel.hourTens,
                                 showsAnimation: showsAnimation)
        hourUnitsViewModel.update(old: updateType.unitsOldValue(timeLabel.hourUnits),
                                  new: timeLabel.hourUnits,
                                  showsAnimation: showsAnimation)
        minuteTensViewModel.update(old: updateType.tensOldValue(timeLabel.minuteTens),
                                   new: timeLabel.minuteTens,
                                   showsAnimation: showsAnimation)
        minuteUnitsViewModel.update(old: updateType.unitsOldValue(timeLabel.minuteUnits),
                                    new: timeLabel.minuteUnits,
                                    showsAnimation: showsAnimation)
        secondTensViewModel.update(old: updateType.tensOldValue(timeLabel.secondTens),
                                   new: timeLabel.secondTens,
                                   showsAnimation: showsAnimation)
        secondUnitsViewModel.update(old: updateType.unitsOldValue(timeLabel.secondUnits),
                                    new: timeLabel.secondUnits,
                                    showsAnimation: showsAnimation)
    }
}
