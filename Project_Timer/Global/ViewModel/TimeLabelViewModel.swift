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
    
    @Published var timeLabel: TimeLabel
    @Published var time: Int {
        didSet {
            self.timeLabel = TimeLabel(time)
            hourTensViewModel.update(old: updateType.tensOldValue(timeLabel.hourTens),
                                     new: timeLabel.hourTens)
            hourUnitsViewModel.update(old: updateType.unitsOldValue(timeLabel.hourUnits),
                                      new: timeLabel.hourUnits)
            minuteTensViewModel.update(old: updateType.tensOldValue(timeLabel.minuteTens),
                                       new: timeLabel.minuteTens)
            minuteUnitsViewModel.update(old: updateType.unitsOldValue(timeLabel.minuteUnits),
                                        new: timeLabel.minuteUnits)
            secondTensViewModel.update(old: updateType.tensOldValue(timeLabel.secondTens),
                                       new: timeLabel.secondTens)
            secondUnitsViewModel.update(old: updateType.unitsOldValue(timeLabel.secondUnits),
                                        new: timeLabel.secondUnits)
        }
    }
    private var showAnimation: Bool
    private var updateType: UpdateType
    
    var hourTensViewModel: SingleTimeLabelViewModel
    var hourUnitsViewModel: SingleTimeLabelViewModel
    var minuteTensViewModel: SingleTimeLabelViewModel
    var minuteUnitsViewModel: SingleTimeLabelViewModel
    var secondTensViewModel: SingleTimeLabelViewModel
    var secondUnitsViewModel: SingleTimeLabelViewModel
    
    init(time: Int, updateType: UpdateType, showAnimation: Bool) {
        let timeLabel = TimeLabel(time)
        self.timeLabel = timeLabel
        self.time = time
        self.showAnimation = showAnimation
        self.updateType = updateType
        self.hourTensViewModel = SingleTimeLabelViewModel(old: updateType.tensOldValue(timeLabel.hourTens),
                                                          new: timeLabel.hourTens,
                                                          showAnimation: showAnimation)
        self.hourUnitsViewModel = SingleTimeLabelViewModel(old: updateType.unitsOldValue(timeLabel.hourUnits),
                                                           new: timeLabel.hourUnits,
                                                           showAnimation: showAnimation)
        self.minuteTensViewModel = SingleTimeLabelViewModel(old: updateType.tensOldValue(timeLabel.minuteTens),
                                                            new: timeLabel.minuteTens,
                                                            showAnimation: showAnimation)
        self.minuteUnitsViewModel = SingleTimeLabelViewModel(old: updateType.unitsOldValue(timeLabel.minuteUnits),
                                                             new: timeLabel.minuteUnits,
                                                             showAnimation: showAnimation)
        self.secondTensViewModel = SingleTimeLabelViewModel(old: updateType.tensOldValue(timeLabel.secondTens),
                                                            new: timeLabel.secondTens,
                                                            showAnimation: showAnimation)
        self.secondUnitsViewModel = SingleTimeLabelViewModel(old: updateType.unitsOldValue(timeLabel.secondUnits),
                                                             new: timeLabel.secondUnits,
                                                             showAnimation: showAnimation)
    }
    
    func updateTime(_ newTime: Int) {
        self.time = newTime
    }
}
