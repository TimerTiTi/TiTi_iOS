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
    case postSignup(TestUserSignupInfo)
    case postSignin(TestUserSigninInfo)
    case getCheckUsername(String)
    case getCheckEmail(String, String)
    case postUpdatePassword(ResetPasswordRequest)
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
        switch self {
        case .postSignup(let testUserSignupInfo):
            return .requestJSONEncodable(testUserSignupInfo)
        case .postSignin(let testUserSignupInfo):
            return .requestJSONEncodable(testUserSignupInfo)
        case .getCheckUsername(let username):
            return .requestParameters(parameters: [
                "username" : username
            ], encoding: URLEncoding.queryString)
        case .getCheckEmail(let username, let email):
            return .requestParameters(parameters: [
                "username": username,
                "email": email
            ], encoding: URLEncoding.queryString)
        case .postUpdatePassword(let resetPasswordRequest):
            return .requestJSONEncodable(resetPasswordRequest)
        }
    }
    
    var headers: [String: String]? {
        return nil
    }
}

