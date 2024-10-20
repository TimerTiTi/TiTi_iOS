//
//  UserAPI.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2024/10/19.
//  Copyright © 2024 FDEE. All rights reserved.
//

import Foundation
import Moya

enum UserAPI {
    /// 티티 서비스에 일반 회원 가입을 해요.
    case register(request: SignupRequest)
}

extension UserAPI: TargetType {
    var baseURL: URL {
        return URL(string: NetworkURL.serverURL_V2 + "/api/user")!
    }
    
    var path: String {
        switch self {
        case .register:
            return "/members/register"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .register:
            return .post
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .register(let request):
            return .requestJSONEncodable(request)
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .register:
            return nil
        }
    }
}
