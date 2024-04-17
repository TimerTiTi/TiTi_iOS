//
//  DailysAPI.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2024/04/17.
//  Copyright © 2024 FDEE. All rights reserved.
//

import Foundation
import Moya

enum DailysAPI {
    case postDailys
    case getDailys
    case postRecordTime
    case getRecordTime
    case getSyncLog
}

extension DailysAPI: TargetType {
    var baseURL: URL {
        return URL(string: NetworkURL.shared.serverURL ?? "nil")!
    }
    
    var path: String {
        switch self {
        case .postDailys, .getDailys:
            return "/dailys/upload"
        case .postRecordTime, .getRecordTime:
            return "/recordTime"
        case .getSyncLog:
            return "/syncLog"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .postDailys, .postRecordTime:
            return .post
        case .getDailys, .getRecordTime, .getSyncLog:
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
