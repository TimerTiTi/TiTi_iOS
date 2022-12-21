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
    let status: NetworkStatus
}

enum NetworkStatus: String {
    case SUCCESS // 200~204
    case FAIL // 400
    case AUTHENTICATION // 401
    case NOTFOUND // 404
    case CONFLICT // 409
    case SERVERERROR // 500
    case DECODEERROR // -1
    
    static func status(_ statusCode: Int) -> NetworkStatus {
        switch statusCode {
        case 200: return .SUCCESS
        case 201: return .SUCCESS
        case 204: return .SUCCESS
        case 401: return .AUTHENTICATION
        case 404: return .NOTFOUND
        case 409: return .CONFLICT
        case 500: return .SERVERERROR
        case -1: return .DECODEERROR
        default: return .FAIL
        }
    }
}
