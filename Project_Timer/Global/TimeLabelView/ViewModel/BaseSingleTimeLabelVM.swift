//
//  BaseSingleTimeLabelVM.swift
//  Project_Timer
//
//  Created by 최수정 on 2022/06/24.
//  Copyright © 2022 FDEE. All rights reserved.
//

import SwiftUI

class BaseSingleTimeLabelVM: ObservableObject {
    @Published var isNewValueVisible: Bool
    @Published var oldValue: Int
    @Published var newValue: Int
    
    init(_ value: Int) {
        self.isNewValueVisible = true
        self.oldValue = value
        self.newValue = value
    }
    
    func update(old: Int, new: Int, showsAnimation: Bool) {
        guard new != newValue else { return }
        
        self.oldValue = old
        self.isNewValueVisible = false
        self.newValue = new
        
        if showsAnimation {
            withAnimation(.easeInOut(duration: 0.3)) {
                self.isNewValueVisible = true
            }
        } else {
            self.isNewValueVisible = true
        }
    }
}
