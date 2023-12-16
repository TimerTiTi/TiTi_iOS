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
    
    var timeLabelData: TimeLabelData {
        return TimeLabelData(self.time)
    }
    
    init(time: Int, fontSize: CGFloat, isWhite: Bool) {
        self.time = time
        self.fontSize = fontSize
        self.isWhite = isWhite
        let timeLabelData = TimeLabelData(time)
        self.hourTensViewModel = BaseSingleTimeLabelVM(timeLabelData.hourTens)
        self.hourUnitsViewModel = BaseSingleTimeLabelVM(timeLabelData.hourUnits)
        self.minuteTensViewModel = BaseSingleTimeLabelVM(timeLabelData.minuteTens)
        self.minuteUnitsViewModel = BaseSingleTimeLabelVM(timeLabelData.minuteUnits)
        self.secondTensViewModel = BaseSingleTimeLabelVM(timeLabelData.secondTens)
        self.secondUnitsViewModel = BaseSingleTimeLabelVM(timeLabelData.secondUnits)
    }
    
    func updateTime(_ newTime: Int, showsAnimation: Bool) {
        let newTimeLabelData = TimeLabelData(newTime)
        hourTensViewModel.update(old: self.timeLabelData.hourTens,
                                 new: newTimeLabelData.hourTens,
                                 showsAnimation: showsAnimation)
        hourUnitsViewModel.update(old: self.timeLabelData.hourUnits,
                                  new: newTimeLabelData.hourUnits,
                                  showsAnimation: showsAnimation)
        minuteTensViewModel.update(old: self.timeLabelData.minuteTens,
                                   new: newTimeLabelData.minuteTens,
                                   showsAnimation: showsAnimation)
        minuteUnitsViewModel.update(old: self.timeLabelData.minuteUnits,
                                    new: newTimeLabelData.minuteUnits,
                                    showsAnimation: showsAnimation)
        secondTensViewModel.update(old: self.timeLabelData.secondTens,
                                   new: newTimeLabelData.secondTens,
                                   showsAnimation: showsAnimation)
        secondUnitsViewModel.update(old: self.timeLabelData.secondUnits,
                                    new: newTimeLabelData.secondUnits,
                                    showsAnimation: showsAnimation)
        self.time = newTime
    }
}
