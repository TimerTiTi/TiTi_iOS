//
//  NotificationUseCase.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2023/12/27.
//  Copyright © 2023 FDEE. All rights reserved.
//

import Foundation

final class NotificationUseCase: NotificationUseCaseInterface {
    func isVisible(info: NotificationInfo) -> Bool {
        guard let noticesInfo = UserDefaultsManager.get(forKey: .noticesInfo) as? [String: [String: String]],
              let noticeInfo = noticesInfo[info.id] else { return true }
        
        // displayCount 체크
        let displayCount = Int(noticeInfo["displayCount"] ?? "") ?? 0
        if displayCount >= 3 {
            return false
        }
        
        // doNotShowUntil 체크
        let formatter = ISO8601DateFormatter()
        guard let doNotShowUntil = noticeInfo["doNotShowUntil"],
              let doNotShowUntilDate = formatter.date(from: doNotShowUntil) else {
            return true
        }
              
        let today = Calendar.current.startOfDay(for: Date())
        let doNotShowUntilDay = Calendar.current.startOfDay(for: doNotShowUntilDate)
        
        return today > doNotShowUntilDay
    }
    
    func updateDisplayCount(info: NotificationInfo) {
        var noticesInfo = UserDefaultsManager.get(forKey: .noticesInfo) as? [String: [String: String]] ?? [:]
        var noticeInfo = noticesInfo[info.id] ?? [:]
        
        let currentCount = Int(noticeInfo["displayCount"] ?? "") ?? 0
        noticeInfo["displayCount"] = "\(currentCount + 1)"
        
        noticesInfo[info.id] = noticeInfo
        UserDefaultsManager.set(to: noticesInfo, forKey: .noticesInfo)
    }
    
    func savePassDay(info: NotificationInfo, isPass: Bool) {
        var noticesInfo = UserDefaultsManager.get(forKey: .noticesInfo) as? [String: [String: String]] ?? [:]
        var noticeInfo = noticesInfo[info.id] ?? [:]
        
        if isPass {
            let futureDate = Calendar.current.date(byAdding: .day, value: 6, to: Date())!
            let dateString = ISO8601DateFormatter().string(from: futureDate)
            noticeInfo["doNotShowUntil"] = dateString
        } else {
            noticeInfo.removeValue(forKey: "doNotShowUntil")
        }
        
        noticesInfo[info.id] = noticeInfo
        UserDefaultsManager.set(to: noticesInfo, forKey: .noticesInfo)
    }
    
    func reset(info: NotificationInfo) {
        var noticesInfo = UserDefaultsManager.get(forKey: .noticesInfo) as? [String: [String: String]] ?? [:]
        noticesInfo.removeValue(forKey: info.id)
        UserDefaultsManager.set(to: noticesInfo, forKey: .noticesInfo)
    }
}
