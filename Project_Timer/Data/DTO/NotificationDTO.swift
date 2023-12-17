//
//  NotificationDTO.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2023/12/17.
//  Copyright © 2023 FDEE. All rights reserved.
//

import Foundation

struct NotificationDTO: Decodable {
    var title: String
    var text: String
    var notis: [NotificationDetailDTO]
}

struct NotificationDetailDTO: Decodable {
    var title: String
    var text: String
    var isDate: Bool
}

extension NotificationDTO {
    func toDomain() -> NotificationInfo {
        return .init(
            title: self.title,
            text: self.text,
            notis: self.notis.map { $0.toDomain() }
        )
    }
}

extension NotificationDetailDTO {
    func toDomain() -> NotificationDetailInfo {
        return .init(
            title: self.title,
            text: self.text,
            isDate: self.isDate
        )
    }
}
