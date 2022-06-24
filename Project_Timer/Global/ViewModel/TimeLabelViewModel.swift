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
        
        func oldValue(_ newValue: Int) -> Int {
            switch self {
            case .countDown:
                return newValue + 1
            case .countUp:
                return newValue - 1
            }
        }
    }
    
    @Published var oldHourTens: Int
    @Published var oldHourUnits: Int
    @Published var oldMinuteTens: Int
    @Published var oldMinuteUnits: Int
    @Published var oldSecondTens: Int
    @Published var oldSecondUnits: Int
    
    @Published var newHourTens: Int
    @Published var newHourUnits: Int
    @Published var newMinuteTens: Int
    @Published var newMinuteUnits: Int
    @Published var newSecondTens: Int
    @Published var newSecondUnits: Int
    
    @Published var updateHourTens: Bool = true
    @Published var updateHourUnits: Bool = true
    @Published var updateMinuteTens: Bool = true
    @Published var updateMinuteUnits: Bool = true
    @Published var updateSecondTens: Bool = true
    @Published var updateSecondUnits: Bool = true
    
    private var updateType: UpdateType
    private var timeLabel: TimeLabel
    
    init(time: Int, type: UpdateType) {
        let timeLabel = Times.toTimeLabel(time)
        self.timeLabel = timeLabel
        self.newHourTens = timeLabel.hourTens
        self.newHourUnits = timeLabel.hourUnits
        self.newMinuteTens = timeLabel.minuteTens
        self.newMinuteUnits = timeLabel.minuteUnits
        self.newSecondTens = timeLabel.secondTens
        self.newSecondUnits = timeLabel.secondUnits
        self.oldHourTens = type.oldValue(timeLabel.hourTens)
        self.oldHourUnits = type.oldValue(timeLabel.hourUnits)
        self.oldMinuteTens = type.oldValue(timeLabel.minuteTens)
        self.oldMinuteUnits = type.oldValue(timeLabel.minuteUnits)
        self.oldSecondTens = type.oldValue(timeLabel.secondTens)
        self.oldSecondUnits = type.oldValue(timeLabel.secondUnits)
        self.updateType = type
    }
    
    func updateTime(_ newTime: Int) {
        self.timeLabel = Times.toTimeLabel(newTime)
        
        if timeLabel.secondTens != self.newSecondTens {
            oldSecondTens = self.updateType.oldValue(timeLabel.secondTens)
            updateSecondTens = false
            newSecondTens = timeLabel.secondTens
            
            withAnimation(.easeIn(duration: 0.2)) {
                self.updateSecondTens = true
            }
        }
        
        if timeLabel.secondUnits != self.newSecondUnits {
            oldSecondUnits = self.updateType.oldValue(timeLabel.secondUnits)
            updateSecondUnits = false
            newSecondUnits = timeLabel.secondUnits
            
            withAnimation(.easeIn(duration: 0.2)) {
                self.updateSecondUnits = true
            }
        }
        
        // TODO: 분, 시간 표시 라벨도 작업 필요
        // TODO: 하드코딩 리팩토링 필요 - SingleTimeLableViewModel 구현 등의 방법이 있음.
    }
}
