//
//  VerifyAuthCodeResponse.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2024/10/01.
//  Copyright © 2024 FDEE. All rights reserved.
//

import Foundation

struct VerifyAuthCodeResponse: Decodable {
    let code: String
    let message: String
    let authToken: String
}

extension VerifyAuthCodeResponse {
    func toDomain() -> VerifyAuthCodeInfo {
        return .init(
            detailInfo: .init(code: self.code, message: self.message),
            authToken: self.authToken
        )
    }
}
