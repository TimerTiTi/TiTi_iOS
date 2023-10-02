//
//  NetworkError.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2023/10/02.
//  Copyright © 2023 FDEE. All rights reserved.
//

import Foundation

enum NetworkError: Error {
    case FAIL
    case TIMEOUT
    case DECODEERROR
    case CLIENTERROR(String?) // 400
    case AUTHENTICATION(String?) // 401
    case NOTFOUND(String?) // 404
    case CONFLICT(String?) // 409
    case SERVERERROR(String?) // 500
    
    static func error(_ result: NetworkResult) -> NetworkError {
        switch result.status {
        case .TIMEOUT:
            return .TIMEOUT
        case .SERVER(let statusCode):
            return serverError(statusCode: statusCode, data: result.data)
        default:
            return .FAIL
        }
    }
    
    static func serverError(statusCode: Int, data: Data?) -> NetworkError {
        // MARK: Decoding 로직 필요
        let errorMessage: String? = ""
        switch statusCode {
        case 400:
            return .CLIENTERROR(errorMessage)
        case 401:
            return .AUTHENTICATION(errorMessage)
        case 404:
            return .NOTFOUND(errorMessage)
        case 409:
            return .CONFLICT(errorMessage)
        case 500:
            return .SERVERERROR(errorMessage)
        default:
            return .FAIL
        }
    }
}
