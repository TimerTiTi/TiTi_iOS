//
//  SingleTimeLabelViewModel.swift
//  Project_Timer
//
//  Created by 최수정 on 2022/06/24.
//  Copyright © 2022 FDEE. All rights reserved.
//

import SwiftUI

class SingleTimeLabelViewModel: ObservableObject {
    enum DigitType {
        case tens
        case units
    }
    
    @Published var oldValue: Int
    @Published var newValue: Int
    @Published var isUpdateComplete: Bool
    private var updateType: TimeLabelViewModel.UpdateType
    private var digitType: DigitType
    
    init(val: Int, updateType: TimeLabelViewModel.UpdateType, digitType: DigitType) {
        self.oldValue = digitType == .tens ? updateType.tensOldValue(val) : updateType.unitsOldValue(val)
        self.newValue = val
        self.isUpdateComplete = true
        self.updateType = updateType
        self.digitType = digitType
    }
    
    func update(_ val: Int) {
        guard newValue != val else { return }
        
        self.oldValue = self.digitType == .tens ? self.updateType.tensOldValue(val) : self.updateType.unitsOldValue(val)
        self.isUpdateComplete = false
        self.newValue = val
        
        withAnimation(.easeIn(duration: 0.2)) {
            self.isUpdateComplete = true
        }
    }
}
