//
//  SignupInfo.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2023/10/29.
//  Copyright © 2023 FDEE. All rights reserved.
//

import Foundation
import Combine

struct SignupEmailInfo {
    let email: String
    let verificationKey: String
}

struct SignupPasswordInfo {
    let password: String
}

struct SignupVenderInfo {
    let vender: SignupInfo.vender
    let id: String
    let email: String?
}

struct SignupNicknameInfo {
    let nickname: String
}

struct SignupTermsInfo {
    let marketingObservable: Bool
}

struct SignupInfo {
    enum type {
        case normal
        case vender
        case venderWithEmail
    }
    enum vender {
        case apple
        case google
    }
}
