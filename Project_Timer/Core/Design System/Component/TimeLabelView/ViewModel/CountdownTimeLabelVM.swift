//
//  CountdownTimeLabelVM.swift
//  Project_Timer
//
//  Created by 최수정 on 2022/07/08.
//  Copyright © 2022 FDEE. All rights reserved.
//

import SwiftUI

class CountdownTimeLabelVM: ObservableObject {
    @Published var timeLabelVM: BaseTimeLabelVM
    @Published var time: Int
    
    init(time: Int, fontSize: CGFloat, isWhite: Bool) {
        self.time = time
        self.timeLabelVM = BaseTimeLabelVM(time: abs(time), fontSize: fontSize, isWhite: isWhite)
    }
    
    func updateTime(_ newTime: Int, showsAnimation: Bool) {
        self.time = newTime
        self.timeLabelVM.updateTime(abs(newTime), showsAnimation: showsAnimation)
    }
    
    func updateRunning(to isRunning: Bool) {
        self.timeLabelVM.isRunning = isRunning
    }
    
    func updateIsWhite(to isWhite: Bool) {
        self.timeLabelVM.isWhite = isWhite
    }
}
