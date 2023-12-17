//
//  NotificationDTO.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2023/12/17.
//  Copyright © 2023 FDEE. All rights reserved.
//

import Foundation

struct NotificationDTO: Decodable, FirestoreValue {
    var title: StringValue
    var text: StringValue
    var notiTitles: StringArrayValue
    var notiTexts: StringArrayValue
    var visible: BooleanValue
    
    private enum RootKey: String, CodingKey {
        case fields
    }
    
    private enum FieldKeys: String, CodingKey {
        case title
        case text
        case notiTitles
        case notiTexts
        case visible
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: RootKey.self)
        let fieldContainer = try container.nestedContainer(keyedBy: FieldKeys.self, forKey: .fields)
        
        self.title = try fieldContainer.decode(StringValue.self, forKey: .title)
        self.text = try fieldContainer.decode(StringValue.self, forKey: .text)
        self.notiTitles = try fieldContainer.decode(StringArrayValue.self, forKey: .notiTitles)
        self.notiTexts = try fieldContainer.decode(StringArrayValue.self, forKey: .notiTexts)
        self.visible = try fieldContainer.decode(BooleanValue.self, forKey: .visible)
        
        self.title = transString(self.title)
        self.text = transString(self.text)
    }
}

extension NotificationDTO {
    func toDomain() -> NotificationInfo {
        return .init(
            title: self.title.value,
            text: self.text.value,
            notis: self.transToDetailInfos()
        )
    }
    
    func transToDetailInfos() -> [NotificationDetailInfo] {
        let titles = self.notiTitles.arrayValue.values.map { $0.value }
        let texts = self.notiTexts.arrayValue.values.map { $0.value }
        
        return zip(titles, texts).map {
            NotificationDetailInfo(title: $0.0, text: $0.1)
        }
    }
}
