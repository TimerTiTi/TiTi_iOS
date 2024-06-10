//
//  UserDefaultsManager.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2022/03/12.
//  Copyright © 2022 FDEE. All rights reserved.
//

import Foundation

struct UserDefaultsManager {
    enum Keys: String {
        // app start
        case isFirst = "isFirst"
        case VCNum = "VCNum"
        // notification
        case timer5minPushable = "timer5minPushable"
        case timerPushable = "timerPushable"
        case stopwatchPushable = "stopwatchPushable"
        // alert
        case updatePushable = "updatePushable"
        // control
        case timelabelsAnimation = "timelabelsAnimation"
        case bigUI = "bigUI"
        case flipToStartRecording = "flipToStartRecording"
        case keepTheScreenOn = "keepTheScreenOn"
        // graph
        case checks = "checks"
        case lastDailyGraphForm = "lastDailyGraphForm"
        // color
        case startColor = "startColor"
        case reverseColor = "reverseColor"
        case stopwatchTextIsWhite = "stopwatchTextIsWhite"
        case timerTextIsWhite = "timerTextIsWhite"
        // recordTimes
        case goalTimeOfMonth
        case goalTimeOfWeek
        case goalTimeOfDaily
        // signin
        case signinInTestServerV1 = "loginInTestServerV1"
        case lastUploadedDateV1
        // widget color
        case calendarWidgetColor
        case calendarWidgetColorIsReverse
        case calendarWidgetTargetTime
        // language
        case languageCode
        // Notification
        case notificationPassDay
        // daily
        case didRemoveEmptyDailys
    }
    
    static func set<T>(to: T, forKey: Self.Keys) {
        UserDefaults.standard.setValue(to, forKey: forKey.rawValue)
        print("UserDefaultsManager: save \(forKey) complete")
    }
    
    static func get(forKey: Self.Keys) -> Any? {
        return UserDefaults.standard.object(forKey: forKey.rawValue)
    }
    
    static func delete(forKey: Self.Keys) {
        UserDefaults.standard.removeObject(forKey: forKey.rawValue)
    }
}
