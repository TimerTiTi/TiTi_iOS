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
    @Published var timeLabel: TimeLabel
    @Published var time: Int {
        didSet {
            self.timeLabel = TimeLabel.toTimeLabel(time)
            hourTensViewModel.update(timeLabel.hourTens)
            hourUnitsViewModel.update(timeLabel.hourUnits)
            minuteTensViewModel.update(timeLabel.minuteTens)
            minuteUnitsViewModel.update(timeLabel.minuteUnits)
            secondTensViewModel.update(timeLabel.secondTens)
            secondUnitsViewModel.update(timeLabel.secondUnits)
        }
    }
    private var updateType: SingleTimeLabelViewModel.UpdateType
    
    init(time: Int, updateType: SingleTimeLabelViewModel.UpdateType, showAnimation: Bool) {
        self.showAnimation = showAnimation
        self.timeLabel = TimeLabel.toTimeLabel(time)
        self.time = time
        self.updateType = updateType
        let timeLabel = TimeLabel.toTimeLabel(time)
        self.hourTensViewModel = SingleTimeLabelViewModel(value: timeLabel.hourTens,
                                                          updateType: updateType,
                                                          digitType: .tens,
                                                          showAnimation: showAnimation)
        self.hourUnitsViewModel = SingleTimeLabelViewModel(value: timeLabel.hourUnits,
                                                           updateType: updateType,
                                                           digitType: .units,
                                                           showAnimation: showAnimation)
        self.minuteTensViewModel = SingleTimeLabelViewModel(value: timeLabel.minuteTens,
                                                            updateType: updateType,
                                                            digitType: .tens,
                                                            showAnimation: showAnimation)
        self.minuteUnitsViewModel = SingleTimeLabelViewModel(value: timeLabel.minuteUnits,
                                                             updateType: updateType,
                                                             digitType: .units,
                                                             showAnimation: showAnimation)
        self.secondTensViewModel = SingleTimeLabelViewModel(value: timeLabel.secondTens,
                                                            updateType: updateType,
                                                            digitType: .tens,
                                                            showAnimation: showAnimation)
        self.secondUnitsViewModel = SingleTimeLabelViewModel(value: timeLabel.secondUnits,
                                                             updateType: updateType,
                                                             digitType: .units,
                                                             showAnimation: showAnimation)
    }
    
    func updateTime(_ newTime: Int) {
        self.time = newTime
    }
}
