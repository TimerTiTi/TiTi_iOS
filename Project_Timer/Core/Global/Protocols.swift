//
//  Protocols.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2022/05/04.
//  Copyright © 2022 FDEE. All rights reserved.
//

import Foundation

protocol TaskChangeable: AnyObject {
    func selectTask(to: String)
}

protocol TimerTimeSettable: AnyObject {
    func updateTimerTime(to: Int)
}

protocol GoalTimeSettable: AnyObject {
    func updateGoalTime(to: Int)
}
