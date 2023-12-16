//
//  NetworkResult.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2023/10/02.
//  Copyright © 2023 FDEE. All rights reserved.
//

import Foundation

struct NetworkResult {
    let status: NetworkStatus
    let data: Data?
}

enum NetworkStatus {
    case SUCCESS // 200~204, 304
    case FAIL // -1
    case TIMEOUT // -2
    case SERVER(Int)
    
    static func status(_ statusCode: Int) -> NetworkStatus {
        switch statusCode {
        case (200...209): return .SUCCESS
        case 304: return .SUCCESS
        default: return .SERVER(statusCode)
        }
    }
}
