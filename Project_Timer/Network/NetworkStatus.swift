//
//  NetworkStatus.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2022/05/21.
//  Copyright © 2022 FDEE. All rights reserved.
//

import Foundation

struct NetworkResult {
    let data: Data?
    let statusCode: Int?
}

enum NetworkStatus: Int {
    case SUCCESS // 200
    case FAIL // 400
    case AUTHENTICATION // 401
    case NOTFOUND // 404
    case CONFLICT // 409
    case SERVERERROR // 500
    case DECODEERROR // -1
    
    func status(statusCode: Int) -> NetworkStatus {
        switch statusCode {
        case 200: return .SUCCESS
        case 401: return .AUTHENTICATION
        case 404: return .NOTFOUND
        case 409: return .CONFLICT
        case 500: return .SERVERERROR
        case -1: return .DECODEERROR
        default: return .FAIL
        }
    }
}
