//
//  NotificationUseCaseInterface.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2023/12/27.
//  Copyright © 2023 FDEE. All rights reserved.
//

import Foundation

protocol NotificationUseCaseInterface {
    func isVisible(info: NotificationInfo) -> Bool
    func updateDisplayCount(info: NotificationInfo)
    func savePassDay(info: NotificationInfo, isPass: Bool)
    func reset(info: NotificationInfo)
}
