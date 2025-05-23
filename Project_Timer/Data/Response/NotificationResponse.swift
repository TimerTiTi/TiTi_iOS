//
//  NotificationDTO.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2023/12/17.
//  Copyright © 2023 FDEE. All rights reserved.
//

import Foundation

struct NotificationResponse: Decodable, FirestoreValue {
    var title: FirebaseStringValue
    var subTitle: FirebaseStringValue
    var text: FirebaseStringValue
    var infoTitles: FirebaseStringArrayValue
    var infoTexts: FirebaseStringArrayValue
    var isVisible: FirebaseBooleanValue
    
    private enum RootKey: String, CodingKey {
        case fields
    }
    
    private enum FieldKeys: String, CodingKey {
        case title
        case subTitle
        case text
        case infoTitles
        case infoTexts
        case isVisible
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: RootKey.self)
        let fieldContainer = try container.nestedContainer(keyedBy: FieldKeys.self, forKey: .fields)
        
        title = try fieldContainer.decode(FirebaseStringValue.self, forKey: .title)
        subTitle = try fieldContainer.decode(FirebaseStringValue.self, forKey: .subTitle)
        text = try fieldContainer.decode(FirebaseStringValue.self, forKey: .text)
        infoTitles = try fieldContainer.decode(FirebaseStringArrayValue.self, forKey: .infoTitles)
        infoTexts = try fieldContainer.decode(FirebaseStringArrayValue.self, forKey: .infoTexts)
        isVisible = try fieldContainer.decode(FirebaseBooleanValue.self, forKey: .isVisible)
        
        title = transString(title)
        text = transString(text)
    }
}

extension NotificationResponse {
    func toDomain() -> NotificationInfo {
        return .init(
            title: title.value,
            subTitle: subTitle.value,
            text: text.value,
            notis: transToDetailInfos()
        )
    }
    
    func transToDetailInfos() -> [NotificationDetailInfo] {
        let titles = infoTitles.arrayValue.values.map { $0.value }
        let texts = infoTexts.arrayValue.values.map { $0.value }
        
        return zip(titles, texts).map {
            NotificationDetailInfo(title: $0.0, text: $0.1)
        }
    }
}
