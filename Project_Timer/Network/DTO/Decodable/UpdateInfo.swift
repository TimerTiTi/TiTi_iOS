//
//  UpdateInfo.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2022/06/04.
//  Copyright © 2022 FDEE. All rights reserved.
//

import Foundation

/// Network 수신 DTO
struct UpdateInfos: Decodable {
    let updateInfos: [UpdateInfo]
    
    enum CodingKeys: String, CodingKey {
        case updateInfos = "documents"
    }
}

/// updateInfos 내 DTO
struct UpdateInfo: Decodable {
    let version: StringValue
    let date: StringValue
    let text: StringValue
    
    private enum RootKey: String, CodingKey {
        case fields
    }
    private enum FieldKeys: String, CodingKey {
        case version, date, text
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: RootKey.self)
        let fieldContainer = try container.nestedContainer(keyedBy: FieldKeys.self, forKey: .fields)
        
        self.version = try fieldContainer.decode(StringValue.self, forKey: .version)
        self.date = try fieldContainer.decode(StringValue.self, forKey: .date)
        let tempText = try fieldContainer.decode(StringValue.self, forKey: .text)
        let textValue = tempText.value.replacingOccurrences(of: "\\n", with: "\n")
        self.text = StringValue(value: textValue)
    }
}
