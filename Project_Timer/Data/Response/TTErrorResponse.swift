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
        case "E9000": // 입력 오류
            return Localized.string(.Server_Error_Input)
        case "E9001", "E9002", "E9003", "E9004", "E9005": // 요청 오류
            return Localized.string(.Server_Error_Request)
        case "E9006": // 인증정보 오류
            return Localized.string(.Server_Error_Authentication)
        case "E9007": // 권한 오류
            return Localized.string(.Server_Error_Permission)
        case "E9999": // 서버 오류
            return Localized.string(.Server_Error_Server)
        default: // 서버 오류
            return Localized.string(.Server_Error_Server)
        }
    }
    
    var errorMessage: String {
        switch code {
        case "E9000":
            return Localized.string(.Server_Error_InputDesc)
        case "E9001", "E9002", "E9003", "E9004", "E9005":
            return Localized.string(.Server_Error_ServiceDesc)
        case "E9006":
            return Localized.string(.Server_Error_AuthenticationDesc)
        case "E9007":
            return Localized.string(.Server_Error_TryAgainDesc)
        case "E9999":
            return Localized.string(.Server_Error_ServerDesc)
        default:
            return Localized.string(.Server_Error_ServerDesc)
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
