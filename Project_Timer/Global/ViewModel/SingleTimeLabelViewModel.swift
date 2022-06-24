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
    
    @Published var oldValue: Int
    @Published var newValue: Int
    @Published var isUpdateComplete: Bool
    private var updateType: UpdateType
    
    init(val: Int, type: UpdateType) {
        self.oldValue = type.oldValue(val)
        self.newValue = val
        self.isUpdateComplete = false
        self.updateType = type
    }
    
    func update(_ val: Int) {
        guard newValue != val else { return }
        
        self.oldValue = self.updateType.oldValue(val)
        self.isUpdateComplete = false
        self.newValue = val
        
        withAnimation(.easeIn(duration: 0.2)) {
            self.isUpdateComplete = true
        }
    }
}
