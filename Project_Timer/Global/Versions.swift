//
//  Versions.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2023/02/14.
//  Copyright © 2023 FDEE. All rights reserved.
//

import Foundation

struct Versions {
    /// useage 버튼 추가시 key 추가
    enum Keys: String {
        case todolistCheckVer
        case timerCheckVer
        case stopwatchCheckVer
        case updateSharedUserDefaultsCheckVer
    }
    /// useage 표시 기준 버전, 신기능 추가시 값 변경 필요
    enum Standard {
        static let timer = "7.13"
        static let stopwatch = "7.13"
        static let todolist = "7.12"
        static let sharedUserDefaults = "7.14"
    }
    
    static func check(forKey key: Versions.Keys) -> Bool {
        let lastCheckedVer = UserDefaults.standard.object(forKey: key.rawValue) as? String ?? "7.11"
        var checkVer = ""
        
        switch key {
        case .timerCheckVer:
            checkVer = Standard.timer
        case .stopwatchCheckVer:
            checkVer = Standard.stopwatch
        case.todolistCheckVer:
            checkVer = Standard.todolist
        case .updateSharedUserDefaultsCheckVer:
            checkVer = Standard.sharedUserDefaults
        }
        
        return checkVer.compare(lastCheckedVer, options: .numeric) == .orderedDescending
    }
    
    static func update(forKey key: Versions.Keys) {
        let currentVer = String.currentVersion
        UserDefaults.standard.setValue(currentVer, forKey: key.rawValue)
    }
}
