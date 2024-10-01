//
//  VerifyAuthCodeRequest.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2024/10/01.
//  Copyright © 2024 FDEE. All rights reserved.
//

import Foundation

struct VerifyAuthCodeRequest: Encodable {
    let authKey: String
    let authCode: String
}
