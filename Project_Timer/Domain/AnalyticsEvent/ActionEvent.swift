//
//  ActionEvent.swift
//  Project_Timer
//
//  Created by Minsang on 5/28/25.
//  Copyright © 2025 FDEE. All rights reserved.
//

import Foundation

enum ActionEvent: AnalyticsEvent {
    var emoji: String { "📍" }
    var category: String { "action" }
    
    case action_startTimer
    case action_startStopwatch
    
    var name: String {
        switch self {
        case .action_startTimer: "action_startTimer"
        case .action_startStopwatch: "action_startStopwatch"
        }
    }
    
    var parameters: [String : Any]? {
        nil
    }
}
