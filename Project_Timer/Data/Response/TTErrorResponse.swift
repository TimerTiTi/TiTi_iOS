//
//  TTErrorResponse.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2024/05/15.
//  Copyright © 2024 FDEE. All rights reserved.
//

import Foundation

/// TiTi 에러
struct TTErrorResponse: Decodable {
    let code: String
    let message: String
    let errors: [TTError]
    
    var logMessage: String {
        return self.errors
            .map { $0.logMessage }
            .joined(separator: "\n")
    }
    
    var errorTitle: String {
        switch self.code {
        case "E9000":
            return "잘못된 입력 오류"
        case "E9001", "E9002", "E9003", "E9004", "E9005":
            return "잘못된 요청 오류"
        case "E9006":
            return "인증정보 오류"
        case "E9007":
            return "잘못된 권한 오류"
        case "E9999":
            return "서버 오류"
        default:
            return "오류 발생"
        }
    }
    
    var errorMessage: String {
        switch code {
        case "E9000":
            return "입력값을 확인 후 다시 시도해주세요"
        case "E9001", "E9002", "E9003", "E9004", "E9005":
            return "개발자 실수로 오류가 발생했어요 🥲\n(\(self.code))"
        case "E9006":
            return "인증정보가 만료되어 다시 로그인해주세요"
        case "E9007":
            return "계속 문제가 발생하는 경우 문의해주세요\n(\(self.code))"
        case "E9999":
            return "서버문제가 발생했어요 🥲\n(\(self.code))"
        default:
            return "계속 문제가 발생하는 경우 문의해주세요\n(\(self.code))"
        }
    }
}

struct TTError: Decodable {
    let field: String
    let value: String
    let reason: String
    
    var logMessage: String {
        return "[\(field) 값 오류](\(value)): \(reason)"
    }
}
