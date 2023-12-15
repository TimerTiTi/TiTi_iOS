//
//  FunctionInfo.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2022/06/05.
//  Copyright © 2022 FDEE. All rights reserved.
//

import Foundation

/// Network 수신 DTO
struct FunctionInfos: Decodable {
    let functionInfos: [FunctionInfo]
    
    enum CodingKeys: String, CodingKey {
        case functionInfos = "documents"
    }
}

/// survayInfos 내 DTO
struct FunctionInfo: Decodable {
    let title: StringValue
    let url: StringValue
    
    private enum RootKey: String, CodingKey {
        case fields
    }
    private enum FieldKeys: String, CodingKey {
        case title, url
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: RootKey.self)
        let fieldContainer = try container.nestedContainer(keyedBy: FieldKeys.self, forKey: .fields)
        
        self.title = try fieldContainer.decode(StringValue.self, forKey: .title)
        self.url = try fieldContainer.decode(StringValue.self, forKey: .url)
    }
}
