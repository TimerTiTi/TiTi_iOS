//
//  SingleTimeLabelViewModel.swift
//  Project_Timer
//
//  Created by 최수정 on 2022/06/24.
//  Copyright © 2022 FDEE. All rights reserved.
//

import SwiftUI

class SingleTimeLabelViewModel: ObservableObject {
    @Published var isUpdateComplete: Bool
    @Published var oldValue: Int
    @Published var newValue: Int
    private var showAnimation: Bool
    
    init(old: Int, new: Int, showAnimation: Bool) {
        self.isUpdateComplete = true
        self.oldValue = old
        self.newValue = new
        self.showAnimation = showAnimation
    }
    
    func update(old: Int, new: Int) {
        guard new != newValue else { return }
        
        self.oldValue = old
        self.isUpdateComplete = false
        self.newValue = new
        
        if showAnimation {
            withAnimation(.easeInOut(duration: 0.5)) {
                self.isUpdateComplete = true
            }
        } else {
            self.isUpdateComplete = true
        }
    }
}
