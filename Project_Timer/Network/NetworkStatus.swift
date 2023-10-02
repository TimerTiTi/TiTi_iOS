//
//  NetworkStatus.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2022/05/21.
//  Copyright © 2022 FDEE. All rights reserved.
//

import Foundation

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



//case SUCCESS // 200~204, 304
//case CLIENTERROR // 400
//case AUTHENTICATION // 401
//case NOTFOUND // 404
//case CONFLICT // 409
//case SERVERERROR // 500
//case DECODEERROR // -1
//case TIMEOUT // -2
