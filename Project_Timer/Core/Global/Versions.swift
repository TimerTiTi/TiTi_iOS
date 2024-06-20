//
//  Versions.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2023/02/14.
//  Copyright © 2023 FDEE. All rights reserved.
//

import Foundation

struct Versions {
    
    static private var lastUpdateVersion: String {
        UserDefaultsManager.get(forKey: .lastUpdateVersion) as? String ?? "7.11"
    }
    
    /// useage 버튼 추가시 key 추가
    private enum Keys: String, CaseIterable {
        case updateSharedUserDefaultsCheckVer = "7.14"
        case removeEmptyDailys = "7.17"
    }
    
    static func update() {
        if lastUpdateVersion == String.currentVersion { return }
        
        for key in Keys.allCases {
            if !check(forKey: key) { continue }
            switch key {
            case .updateSharedUserDefaultsCheckVer:
                configureSharedUserDefaults()
            case .removeEmptyDailys:
                checkEmptyDailys()
            }
        }
        
        UserDefaultsManager.set(to: String.currentVersion, forKey: .lastUpdateVersion)
    }
    
    static private func check(forKey key: Versions.Keys) -> Bool {
        let checkVer = key.rawValue
        return checkVer.compare(lastUpdateVersion, options: .numeric) == .orderedDescending
    }
    
    static private func configureSharedUserDefaults() {
        /// UserDefaults.standard -> shared 반영
        UserDefaults.updateShared()
    }
    
    static private func checkEmptyDailys() {
        RecordsManager.shared.dailyManager.removeEmptyDailys()
    }
}
