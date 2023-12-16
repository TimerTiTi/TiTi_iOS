//
//  PredicateChecker.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2023/10/10.
//  Copyright © 2023 FDEE. All rights reserved.
//

import Foundation

struct PredicateChecker {
    static let allowedSpecialCharacters = "!@#$%^&*()"
    
    static let emailCheck = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}" // email 형식
    static let passwordCheck = "^(?=.*[A-Za-z])(?=.*[0-9])(?=.*[\(allowedSpecialCharacters)]).*$" // 8자리 ~ 20자리 영어 + 숫자 + 허용된 특수문자
    static let nicknameCheck = "[A-Z0-9a-z,./<>?;':!@#$%^&*()-=_+]{2,12}" // 닉네임 형식
    
    static func resultOfPredicate(text: String, cheker: String) -> Bool {
        let predicate = NSPredicate(format: "SELF MATCHES %@", cheker)
        return predicate.evaluate(with: text)
    }
    
    static func isValidEmail(_ email: String) -> Bool {
        return resultOfPredicate(text: email, cheker: emailCheck)
    }
    
    static func isValidPassword(_ password: String) -> Bool {
        return resultOfPredicate(text: password, cheker: passwordCheck) && password.count >= 8 && password.count <= 20
    }
    
    static func isValidNickname(_ nickname: String) -> Bool {
        return resultOfPredicate(text: nickname, cheker: nicknameCheck)
    }
}
