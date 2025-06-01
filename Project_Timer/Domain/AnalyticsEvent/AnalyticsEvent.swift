//
//  AnalyticsEvent.swift
//  Project_Timer
//
//  Created by Minsang on 5/28/25.
//  Copyright © 2025 FDEE. All rights reserved.
//

import Foundation

protocol AnalyticsEvent {
    var emoji: String { get }
    var category: String { get }
    var name: String { get }
    var parameters: [String: Any]? { get }
}
