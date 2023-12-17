//
//  NotificationDTO.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2023/12/17.
//  Copyright © 2023 FDEE. All rights reserved.
//

import Foundation

struct NotificationDTO: Decodable {
    var title: StringValue
    var text: StringValue
    var notiTitles: StringArrayValue
    var notiTexts: StringArrayValue
    
    private enum RootKey: String, CodingKey {
        case fields
    }
    
    private enum FieldKeys: String, CodingKey {
        case title
        case text
        case notiTitles
        case notiTexts
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: RootKey.self)
        let fieldContainer = try container.nestedContainer(keyedBy: FieldKeys.self, forKey: .fields)
        
        self.title = try fieldContainer.decode(StringValue.self, forKey: .title)
        self.text = try fieldContainer.decode(StringValue.self, forKey: .text)
        self.notiTitles = try fieldContainer.decode(StringArrayValue.self, forKey: .notiTitles)
        self.notiTexts = try fieldContainer.decode(StringArrayValue.self, forKey: .notiTexts)
    }
}

//struct NotificationDetailDTO: Decodable {
//    var title: String
//    var text: String
//    var isDate: Bool
//}
//
//extension NotificationDTO {
//    func toDomain() -> NotificationInfo {
//        return .init(
//            title: self.title,
//            text: self.text,
//            notis: self.notis.map { $0.toDomain() }
//        )
//    }
//}
//
//extension NotificationDetailDTO {
//    func toDomain() -> NotificationDetailInfo {
//        return .init(
//            title: self.title,
//            text: self.text,
//            isDate: self.isDate
//        )
//    }
//}
