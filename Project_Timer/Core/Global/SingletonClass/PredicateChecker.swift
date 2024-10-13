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
    static var emailCheck: String { "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}" }
    /// 패스워드 정규식, 8자 ~ 20자 이내 (10/13 기준)
    static var passwordCheckInServer: String { "^(?=.*\\d)(?=.*[a-zA-Z])(?=.*[~!@#$%^&()])[A-Za-z\\d~!@#$%^&()]{8,20}$" }
    /// 닉네임 정규식, 2자 ~ 15자 이내
    static var nicknameCheck: String { "[A-Z0-9a-z,./<>?;':!@#$%^&*()-=_+]{2,15}" }
    
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
