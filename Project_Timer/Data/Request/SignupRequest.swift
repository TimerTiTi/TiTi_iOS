//
//  SignupRequest.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2024/10/19.
//  Copyright © 2024 FDEE. All rights reserved.
//

import Foundation

struct SignupRequest: Encodable {
    let username: String
    let encodedEncryptedPassword: String
    let nickname: String
    let authToken: String
}
