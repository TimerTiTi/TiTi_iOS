//
//  UserAPI.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2024/09/01.
//  Copyright © 2024 FDEE. All rights reserved.
//

import Foundation
import Moya

enum UserAPI {
    /// 존재하는 Username인지 확인해요.
    case checkUsername(request: CheckUsernameRequest)
}

extension UserAPI: TargetType {
    var baseURL: URL {
        return URL(string: NetworkURL.serverURL_V2)!
    }
    
    var path: String {
        switch self {
        case .checkUsername:
            return "/members/check"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .checkUsername:
            return .get
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .checkUsername(let request):
            return .requestParameters(
                parameters: Self.parameters(from: request),
                encoding: URLEncoding.queryString
            )
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .checkUsername:
            return nil
        }
    }
}
