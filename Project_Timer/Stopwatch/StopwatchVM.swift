//
//  StopwatchVM.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2022/04/29.
//  Copyright © 2022 FDEE. All rights reserved.
//

import Foundation
import Combine

final class StopwatchVM {
    @Published private(set) var timerStopped = true
    @Published private(set) var stopUI = true
    private var timer = Timer()
    
}
