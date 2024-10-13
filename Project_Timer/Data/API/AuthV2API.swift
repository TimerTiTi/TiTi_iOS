//
//  AuthV2API.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2024/09/29.
//  Copyright © 2024 FDEE. All rights reserved.
//

import Foundation
import Moya

enum AuthV2API {
    /// 존재하는 Username인지 확인해요.
    case checkUsername(request: CheckUsernameRequest)
    /// 인증 코드를 생성하여 대상에게 전송해요.
    case postAuthcode(request: PostAuthCodeRequest)
    /// 인증 코드를 검증해요.
    case verifyAuthcode(request: VerifyAuthCodeRequest)
}

extension AuthV2API: TargetType {
    var baseURL: URL {
        return URL(string: NetworkURL.serverURL_V2 + "/api/auth")!
    }
    
    var path: String {
        switch self {
        case .checkUsername:
            return "/accounts/check"
        case .postAuthcode:
            return "/code"
        case .verifyAuthcode:
            return "/code/verify"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .checkUsername:
            return .get
        case .postAuthcode, .verifyAuthcode:
            return .post
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .checkUsername(let request):
            return .requestParameters(
                parameters: Self.parameters(from: request),
                encoding: URLEncoding.queryString
            )
        case .postAuthcode(let request):
            return .requestJSONEncodable(request)
        case .verifyAuthcode(let request):
            return .requestJSONEncodable(request)
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .checkUsername, .postAuthcode, .verifyAuthcode:
            return nil
        }
    }
}
