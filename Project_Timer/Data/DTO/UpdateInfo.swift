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
    var updateInfos: [UpdateInfo]
    
    enum CodingKeys: String, CodingKey {
        case updateInfos = "documents"
    }
}

/// updateInfos 내 DTO
struct UpdateInfo: Decodable, FirestoreValue {
    var version: FirebaseStringValue
    var date: FirebaseStringValue
    var text: FirebaseStringValue
    
    private enum RootKey: String, CodingKey {
        case fields
    }
    private enum FieldKeys: String, CodingKey {
        case version, date, text
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: RootKey.self)
        let fieldContainer = try container.nestedContainer(keyedBy: FieldKeys.self, forKey: .fields)
        
        self.version = try fieldContainer.decode(FirebaseStringValue.self, forKey: .version)
        self.date = try fieldContainer.decode(FirebaseStringValue.self, forKey: .date)
        self.text = try fieldContainer.decode(FirebaseStringValue.self, forKey: .text)
        
        self.text = transString(self.text)
    }
}
