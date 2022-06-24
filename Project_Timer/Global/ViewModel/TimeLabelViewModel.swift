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
                return newValue == 9 ? 0 : newValue + 1
            case .countUp:
                return newValue == 0 ? 5 : (newValue - 1)
            }
        }
        
        func unitsOldValue(_ newValue: Int) -> Int {
            switch self {
            case .countDown:
                return newValue + 1
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
//            self.oldHourTens = self.updateType.tensOldValue(timeLabel.hourTens)
//            self.oldHourUnits = self.updateType.unitsOldValue(timeLabel.hourUnits)
//            self.oldMinuteTens = self.updateType.tensOldValue(timeLabel.minuteTens)
//            self.oldMinuteUnits = self.updateType.unitsOldValue(timeLabel.minuteUnits)
//            self.oldSecondTens = self.updateType.tensOldValue(timeLabel.secondTens)
//            self.oldSecondUnits = self.updateType.unitsOldValue(timeLabel.secondUnits)
//
//            self.newHourTens = timeLabel.hourTens
//            self.newHourUnits = timeLabel.hourUnits
//            self.newMinuteTens = timeLabel.minuteTens
//            self.newMinuteUnits = timeLabel.minuteUnits
//            self.newSecondTens = timeLabel.secondTens
//            self.newSecondUnits = timeLabel.secondUnits
        }
    }
    
    init(time: Int, type: UpdateType) {
        let timeLabel = Times.toTimeLabel(time)
        self.timeLabel = timeLabel
        self.updateType = type
        self.hourTensViewModel = SingleTimeLabelViewModel(val: timeLabel.hourTens, type: type)
        self.hourUnitsViewModel = SingleTimeLabelViewModel(val: timeLabel.hourUnits, type: type)
        self.minuteTensViewModel = SingleTimeLabelViewModel(val: timeLabel.minuteTens, type: type)
        self.minuteUnitsViewModel = SingleTimeLabelViewModel(val: timeLabel.minuteUnits, type: type)
        self.secondTensViewModel = SingleTimeLabelViewModel(val: timeLabel.secondTens, type: type)
        self.secondUnitsViewModel = SingleTimeLabelViewModel(val: timeLabel.secondUnits, type: type)
    }
    
    func updateTime(_ newTime: Int) {
        let timeLabel = Times.toTimeLabel(newTime)
        hourTensViewModel.update(timeLabel.hourTens)
        hourUnitsViewModel.update(timeLabel.hourUnits)
        minuteTensViewModel.update(timeLabel.minuteTens)
        minuteUnitsViewModel.update(timeLabel.minuteUnits)
        secondTensViewModel.update(timeLabel.secondTens)
        secondUnitsViewModel.update(timeLabel.secondUnits)
    }
}
