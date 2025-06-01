//
//  FirebaseAnalytics.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2022/08/26.
//  Copyright © 2022 FDEE. All rights reserved.
//

import Foundation
import FirebaseAnalytics

 enum FirebaseAnalytics {
    static func log(_ event: AnalyticsEvent) {
        Analytics.logEvent(event.name, parameters: event.parameters)
        let log = """
        [\(event.emoji)\(event.category)] \(event.name)
        parameters: \(event.parameters ?? [:])
        """
        print(log)
    }
}
