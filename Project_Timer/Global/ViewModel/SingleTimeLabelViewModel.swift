//
//  SingleTimeLabelViewModel.swift
//  Project_Timer
//
//  Created by 최수정 on 2022/06/24.
//  Copyright © 2022 FDEE. All rights reserved.
//

import SwiftUI

class SingleTimeLabelViewModel: ObservableObject {
    enum UpdateType {
        case countUp
        case countDown
    }
    enum DigitType {
        case tens
        case units
    }
    
    @Published var isUpdateComplete: Bool
    @Published var newValue: Int
    var oldValue: Int {
        switch digitType {
        case .tens:
            switch updateType {
            case .countUp:
                return newValue == 0 ? 5 : (newValue - 1)
            case .countDown:
                return newValue == 5 ? 0 : (newValue + 1)
            }
        case .units:
            switch updateType {
            case .countUp:
                return newValue == 0 ? 9 : (newValue - 1)
            case .countDown:
                return newValue == 9 ? 0 : (newValue + 1)
            }
        }
    }
    private var showAnimation: Bool
    private var updateType: UpdateType
    private var digitType: DigitType
    
    init(value: Int, updateType: UpdateType, digitType: DigitType, showAnimation: Bool) {
        self.newValue = value
        self.showAnimation = showAnimation
        self.updateType = updateType
        self.digitType = digitType
        self.isUpdateComplete = true
    }
    
    func update(_ val: Int) {
        guard val != newValue else { return }
        
        self.newValue = val
        self.isUpdateComplete = false
        
        if showAnimation {
            withAnimation(.easeInOut(duration: 0.5)) {
                self.isUpdateComplete = true
            }
        } else {
            self.isUpdateComplete = true
        }
    }
}
