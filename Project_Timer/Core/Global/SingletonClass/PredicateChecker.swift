//
//  PredicateChecker.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2023/10/10.
//  Copyright © 2023 FDEE. All rights reserved.
//

import Foundation

/// 정규식 Checker
struct PredicateChecker {
    /// email 정규식
    static var emailCheck: String { "^[a-zA-Z0-9._%+-]{1,64}@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$(?=.{0,255}$)" }
    /// 패스워드 정규식, 8자 ~ 64자 이내 UNICODE (10/19 기준)
    static var passwordCheckInServer: String { "^[\\S]{8,64}$" }
    /// 닉네임 정규식, 1자 ~ 12자 이내 UNICODE (10/19 기준)
    static var nicknameCheck: String { "^[\\S]{1,12}$" }
    
    static func resultOfPredicate(text: String, cheker: String) -> Bool {
        let predicate = NSPredicate(format: "SELF MATCHES %@", cheker)
        return predicate.evaluate(with: text)
    }
    
    /// email 정규식 통과 여부
    static func isValidEmail(_ email: String) -> Bool {
        return resultOfPredicate(text: email, cheker: emailCheck)
    }
    
    /// 패스워드 정규식 통과 여부
    static func isValidPassword(_ password: String) -> Bool {
        return resultOfPredicate(text: password, cheker: passwordCheckInServer)
    }
    
    /// 닉네임 정규식 통과 여부
    static func isValidNickname(_ nickname: String) -> Bool {
        return resultOfPredicate(text: nickname, cheker: nicknameCheck)
    }
}
