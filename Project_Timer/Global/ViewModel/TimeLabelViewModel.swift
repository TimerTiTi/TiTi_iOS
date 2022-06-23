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
        
        func updatedValue(_ value: Int) -> Int {
            switch self {
            case .countDown:
                if value == 0 {
                    return 9
                } else {
                    return value - 1
                }
            case .countUp:
                if value == 9 {
                    return 0
                } else {
                    return value + 1
                }
            }
        }
    }
    
    @Published var update = true
    @Published var oldValue: Int
    @Published var newValue: Int
    let updateType: UpdateType
    
    init(_ value: Int, type: UpdateType) {
        self.updateType = type
        self.newValue = value
        switch type {
        case .countDown:
            self.oldValue = value + 1
        case .countUp:
            self.oldValue = value - 1
        }
    }
    
    func updateTime() {
        oldValue = updateType.updatedValue(oldValue)
        update = false
        newValue = updateType.updatedValue(newValue)
        
        withAnimation(.easeIn(duration: 0.2)) {
            update = true
        }
    }
}
