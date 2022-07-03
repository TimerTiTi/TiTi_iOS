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

enum NetworkStatus {
    case SUCCESS // 200
    case DECODEERROR
    case FAIL
}
