//
//  ErrorResponse.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2024/05/15.
//  Copyright © 2024 FDEE. All rights reserved.
//

import Foundation

/// TiTi 에러
struct ErrorResponse: Decodable {
    let code: String
    let message: String
    let errors: [String: String]
}
