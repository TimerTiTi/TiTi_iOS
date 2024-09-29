//
//  PostAuthCodeResponse.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2024/09/29.
//  Copyright © 2024 FDEE. All rights reserved.
//

import Foundation

struct PostAuthCodeResponse: Decodable {
    let code: String
    let message: String
    let authKey: String
}

extension PostAuthCodeResponse {
    func toDomain() -> PostAuthCodeInfo {
        return .init(
            detailInfo: .init(code: self.code, message: self.message),
            authKey: self.authKey
        )
    }
}
