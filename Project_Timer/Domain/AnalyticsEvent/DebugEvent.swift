//
//  DebugEvent.swift
//  Project_Timer
//
//  Created by Minsang on 5/28/25.
//  Copyright © 2025 FDEE. All rights reserved.
//

import Foundation

enum DebugEvent: AnalyticsEvent {
    var emoji: String { "🔍" }
    var category: String { "debug" }
    
    case debug_firestoreFail(screen: String, reason: String)
    case debug_serverFail(screen: String, reason: String)
    
    var name: String {
        switch self {
        case .debug_firestoreFail: "debug_firestoreFail"
        case .debug_serverFail: "debug_serverFail"
        }
    }
    
    var parameters: [String : Any]? {
        switch self {
        case let .debug_firestoreFail(screen, reason),
            let .debug_serverFail(screen, reason):
            return [
                "screen": screen,
                "reason": reason
            ]
        }
    }
}

