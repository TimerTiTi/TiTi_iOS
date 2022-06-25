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
                return newValue + 1
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
    
    var oldHourTens: Int
    var oldHourUnits: Int
    var oldMinuteTens: Int
    var oldMinuteUnits: Int
    var oldSecondTens: Int
    var oldSecondUnits: Int
    
    var newHourTens: Int
    var newHourUnits: Int
    var newMinuteTens: Int
    var newMinuteUnits: Int
    var newSecondTens: Int
    var newSecondUnits: Int
    
    @Published var updateHourTens: Bool = true
    @Published var updateHourUnits: Bool = true
    @Published var updateMinuteTens: Bool = true
    @Published var updateMinuteUnits: Bool = true
    @Published var updateSecondTens: Bool = true
    @Published var updateSecondUnits: Bool = true
    
    private var updateType: UpdateType
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
        let timeLabel = TimeLabel.toTimeLabel(time)
        self.timeLabel = timeLabel
        self.newHourTens = timeLabel.hourTens
        self.newHourUnits = timeLabel.hourUnits
        self.newMinuteTens = timeLabel.minuteTens
        self.newMinuteUnits = timeLabel.minuteUnits
        self.newSecondTens = timeLabel.secondTens
        self.newSecondUnits = timeLabel.secondUnits
        self.oldHourTens = type.tensOldValue(timeLabel.hourTens)
        self.oldHourUnits = type.unitsOldValue(timeLabel.hourUnits)
        self.oldMinuteTens = type.tensOldValue(timeLabel.minuteTens)
        self.oldMinuteUnits = type.unitsOldValue(timeLabel.minuteUnits)
        self.oldSecondTens = type.tensOldValue(timeLabel.secondTens)
        self.oldSecondUnits = type.unitsOldValue(timeLabel.secondUnits)
        self.updateType = type
    }
    
    func updateTime(_ newTime: Int) {
        self.timeLabel = TimeLabel.toTimeLabel(newTime)
        
        if timeLabel.secondTens != self.newSecondTens {
            self.oldSecondTens = self.updateType.tensOldValue(self.timeLabel.secondTens)
            self.updateSecondTens = false
            self.newSecondTens = timeLabel.secondTens

            withAnimation(.easeIn(duration: 0.4)) { [weak self] in
                self?.updateSecondTens = true
            }
        }

        if timeLabel.secondUnits != self.newSecondUnits {
            self.oldSecondUnits = self.updateType.unitsOldValue(self.timeLabel.secondUnits)
            self.updateSecondUnits = false
            self.newSecondUnits = timeLabel.secondUnits

            withAnimation(.easeIn(duration: 0.4)) { [weak self] in
                self?.updateSecondUnits = true
            }
        }
        
        // TODO: 분, 시간 표시 라벨도 작업 필요
        // TODO: 하드코딩 리팩토링 필요 - SingleTimeLableViewModel 구현 등의 방법이 있음.
    }
}
