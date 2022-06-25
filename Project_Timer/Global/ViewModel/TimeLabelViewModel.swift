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
    
    private var updateType: UpdateType
    var hourTensViewModel: SingleTimeLabelViewModel
    var hourUnitsViewModel: SingleTimeLabelViewModel
    var minuteTensViewModel: SingleTimeLabelViewModel
    var minuteUnitsViewModel: SingleTimeLabelViewModel
    var secondTensViewModel: SingleTimeLabelViewModel
    var secondUnitsViewModel: SingleTimeLabelViewModel
    private var timeLabel: TimeLabel {
        didSet {
            hourTensViewModel.update(timeLabel.hourTens)
            hourUnitsViewModel.update(timeLabel.hourUnits)
            minuteTensViewModel.update(timeLabel.minuteTens)
            minuteUnitsViewModel.update(timeLabel.minuteUnits)
            secondTensViewModel.update(timeLabel.secondTens)
            secondUnitsViewModel.update(timeLabel.secondUnits)
        }
    }
    
    init(time: Int, updateType: UpdateType) {
        let timeLabel = TimeLabel.toTimeLabel(time)
        self.timeLabel = timeLabel
        self.updateType = updateType
        self.hourTensViewModel = SingleTimeLabelViewModel(val: timeLabel.hourTens,
                                                          updateType: updateType,
                                                          digitType: .tens)
        self.hourUnitsViewModel = SingleTimeLabelViewModel(val: timeLabel.hourUnits,
                                                           updateType: updateType,
                                                           digitType: .units)
        self.minuteTensViewModel = SingleTimeLabelViewModel(val: timeLabel.minuteTens,
                                                            updateType: updateType,
                                                            digitType: .tens)
        self.minuteUnitsViewModel = SingleTimeLabelViewModel(val: timeLabel.minuteUnits,
                                                             updateType: updateType,
                                                             digitType: .units)
        self.secondTensViewModel = SingleTimeLabelViewModel(val: timeLabel.secondTens,
                                                            updateType: updateType,
                                                            digitType: .tens)
        self.secondUnitsViewModel = SingleTimeLabelViewModel(val: timeLabel.secondUnits,
                                                             updateType: updateType,
                                                             digitType: .units)
    }
    
    func updateTime(_ newTime: Int) {
        self.timeLabel = TimeLabel.toTimeLabel(newTime)
    }
}
