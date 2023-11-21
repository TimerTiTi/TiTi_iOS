//
//  SignupInfo.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2023/10/29.
//  Copyright © 2023 FDEE. All rights reserved.
//

import Foundation
import Combine

// MARK: Info
/// 회원가입 type
enum SignupType {
    case normal
    case vender
    case venderWithEmail
}

/// vender 정보
struct SignupVenderInfo {
    enum vender {
        case apple
        case google
    }
    let vender: vender
    let id: String
    let email: String?
}

/// email 정보
struct SignupEmailInfo {
    let email: String
    let verificationKey: String
}

/// password 정보
struct SignupPasswordInfo {
    let password: String
}

/// nickname 정보
struct SignupNicknameInfo {
    let nickname: String
}

/// marketing 정보
struct SignupTermsInfo {
    let marketingObservable: Bool
}

// MARK: Infos
struct SignupInfosForEmail {
    let type: SignupType
    let venderInfo: SignupVenderInfo?
}

struct SignupInfosForPassword {
    let type: SignupType
    let venderInfo: SignupVenderInfo?
    let emailInfo: SignupEmailInfo
}
