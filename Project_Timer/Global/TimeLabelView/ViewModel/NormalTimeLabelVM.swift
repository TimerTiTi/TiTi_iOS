//
//  NormalTimeLabelVM.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2022/10/13.
//  Copyright © 2022 FDEE. All rights reserved.
//

import Foundation

class NormalTimeLabelVM: ObservableObject {
    @Published var timeLabelVM: BaseTimeLabelVM
    
    init(time: Int, fontSize: CGFloat, isWhite: Bool) {
        self.timeLabelVM = BaseTimeLabelVM(time: time, fontSize: fontSize, isWhite: isWhite)
    }
    
    func updateTime(_ newTime: Int, showsAnimation: Bool, darkerMode: Bool) {
        self.timeLabelVM.updateTime(newTime, showsAnimation: showsAnimation, darkerMode: darkerMode)
    }
    
    func updateRunning(to isRunning: Bool) {
        self.timeLabelVM.isRunning = isRunning
    }
    
    func updateIsWhite(to isWhite: Bool) {
        self.timeLabelVM.isWhite = isWhite
    }
}
