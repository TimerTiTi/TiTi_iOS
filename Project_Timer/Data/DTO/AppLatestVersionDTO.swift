//
//  AppLatestVersionDTO.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2023/12/03.
//  Copyright © 2023 FDEE. All rights reserved.
//

import Foundation

struct AppLatestVersionDTO: Decodable {
    let latestVersion: StringValue
    let forced: Bool
    
    private enum RootKey: String, CodingKey {
        case fields
    }
    
    private enum FieldKeys: String, CodingKey {
        case latestVersion
        case forced
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: RootKey.self)
        let fieldContainer = try container.nestedContainer(keyedBy: FieldKeys.self, forKey: .fields)
        
        self.latestVersion = try fieldContainer.decode(StringValue.self, forKey: .latestVersion)
        self.forced = try fieldContainer.decode(Bool.self, forKey: .forced)
    }
}

extension AppLatestVersionDTO {
    func toDomain() -> AppLatestVersionInfo {
        return .init(
            latestVersion: self.latestVersion.value,
            forced: self.forced
        )
    }
}
