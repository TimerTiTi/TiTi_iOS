//
//  FirebaseEvent.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2022/08/26.
//  Copyright © 2022 FDEE. All rights reserved.
//

import Foundation
import FirebaseAnalytics

final class FirebaseEvent {
    static let shared = FirebaseEvent()
    enum Event: String {
        case createRecord
        case editRecord
        case saveRecord
        case editTaskName
        case createTaskName
        case editRecordHistory
        case createRecordInRecord
    }
    
    private init() {}
    
    func postEvent(_ event: Event) {
        Analytics.logEvent(AnalyticsEventSelectContent, parameters: [
            AnalyticsParameterItemID: "id-\(event.rawValue)",
            AnalyticsParameterItemName: event.rawValue,
          AnalyticsParameterContentType: "cont",
        ])
    }
}
