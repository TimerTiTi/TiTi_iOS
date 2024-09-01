//
//  CheckUsernameResponse.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2024/09/01.
//  Copyright © 2024 FDEE. All rights reserved.
//

import Foundation

struct CheckUsernameResponse: Decodable {
    let code: String
    let message: String
    let is_present: Bool
}

extension CheckUsernameResponse {
    func toDomain() -> CheckUsernameInfo {
        return .init(
            detailInfo: .init(code: self.code, message: self.message),
            isNotExist: !self.is_present
        )
    }
}
