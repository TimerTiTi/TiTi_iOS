//
//  CountdownTimeLabelViewModel.swift
//  Project_Timer
//
//  Created by 최수정 on 2022/07/08.
//  Copyright © 2022 FDEE. All rights reserved.
//

import SwiftUI

class CountdownTimeLabelViewModel: ObservableObject {
    var timeLabelViewModel: TimeLabelViewModel
    var fontSize: CGFloat
    @Published var time: Int
    
    init(time: Int, fontSize: CGFloat) {
        self.time = time
        self.fontSize = fontSize
        self.timeLabelViewModel = TimeLabelViewModel(time: abs(time), fontSize: fontSize)
    }
    
    func updateTime(_ newTime: Int, showsAnimation: Bool) {
        self.time = newTime
        self.timeLabelViewModel.updateTime(abs(newTime), showsAnimation: showsAnimation)
    }
}
