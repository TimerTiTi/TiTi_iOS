//
//  FirebaseAPI.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2024/04/17.
//  Copyright © 2024 FDEE. All rights reserved.
//

import Foundation
import Moya

enum FirebaseAPI {
    case getAppVersion
    case getServerURL
    case getNotification
}

extension FirebaseAPI: TargetType {
    var baseURL: URL {
        return URL(string: Infos.FirestoreURL.value)!
    }
    
    var path: String {
        switch self {
        case .getAppVersion:
            #if targetEnvironment(macCatalyst)
            return "/version/macos"
            #else
            return "/version/ios"
            #endif
        case .getServerURL:
            return "/server/url"
        case .getNotification:
            switch Language.current {
            case .ko: return "/notification/ko"
            case .en: return "/notification/en"
            case .zh: return "/notification/zh"
            }
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getAppVersion, .getServerURL, .getNotification:
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
