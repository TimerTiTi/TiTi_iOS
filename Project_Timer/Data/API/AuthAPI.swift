//
//  AuthAPI.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2024/04/17.
//  Copyright © 2024 FDEE. All rights reserved.
//

import Foundation
import Moya

enum AuthAPI {
    case postSignup
    case postSignin
    case getCheckUsername
    case getCheckEmail
    case postUpdatePassword
}

extension AuthAPI: TargetType {
    var baseURL: URL {
        return URL(string: NetworkURL.shared.serverURL ?? "nil")!
    }
    
    var path: String {
        switch self {
        case .postSignup:
            return "/auth/signup"
        case .postSignin:
            return "/auth/login"
        case .getCheckUsername, .getCheckEmail:
            return "/auth/users"
        case .postUpdatePassword:
            return "/auth/users/password"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .postSignup, .postSignin, .postUpdatePassword:
            return .post
        case .getCheckUsername, .getCheckEmail:
            return .get
        }
    }
    
    var task: Moya.Task {
        return .requestPlain
    }
    
    var headers: [String : String]? {
        return nil
    }
}
