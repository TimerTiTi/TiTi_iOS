//
//  TimerStopwatchAttributes.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2023/02/12.
//  Copyright © 2023 FDEE. All rights reserved.
//

import Foundation
import ActivityKit

struct TimerStopwatchAttributes: ActivityAttributes {
    public typealias titiStatus = ContentState
    
    public struct ContentState: Codable, Hashable {
        var taskName: String
        var timer: ClosedRange<Date>
    }
    
    var isTimer: Bool
}
