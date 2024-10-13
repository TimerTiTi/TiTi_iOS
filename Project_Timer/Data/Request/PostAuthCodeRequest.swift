//
//  PostAuthCodeRequest.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2024/09/29.
//  Copyright © 2024 FDEE. All rights reserved.
//

import Foundation

struct PostAuthCodeRequest: Encodable {
    let targetType: String
    let targetValue: String
    let authType: String
}
