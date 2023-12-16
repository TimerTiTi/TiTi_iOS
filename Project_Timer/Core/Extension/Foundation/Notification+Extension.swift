//
//  Notification+Extension.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2022/03/12.
//  Copyright © 2022 FDEE. All rights reserved.
//

import Foundation

extension Notification.Name {
    static let showTabbarController = Self.init(rawValue: "showTabbarController")
    static let setBadge = Self.init(rawValue: "setBadge")
    static let removeBadge = Self.init(rawValue: "removeBadge")
    static let newVersion = Self.init(rawValue: "newVersion")
    static let removeNewRecordWarning = Self.init(rawValue: "removeNewRecordWarning")
}
