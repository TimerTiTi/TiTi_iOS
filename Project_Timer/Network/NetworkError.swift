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
    
    /// 범용적으로 표시될 수 있는 alert title 값, CLIENTERROR의 경우 VM에서 처리
    var title: String {
        switch self {
        case .FAIL:
            return "Network Error".localized()
        case .TIMEOUT:
            return "Network Timeout".localized()
        case .DECODEERROR:
            return "Network Fetch Error".localized()
        case .AUTHENTICATION(_):
            return "Authentication Error".localized()
        case .NOTFOUND(_):
            return "Network Fetch Error".localized()
        case .CONFLICT(_):
            return "Signup Error".localized()
        case .SERVERERROR(_):
            return "Server Error".localized()
        default:
            return "Network Error".localized()
        }
    }
    
    /// 범용적으로 표시될 수 있는 alert message 값, CLIENTERROR의 경우 VM에서 처리
    var message: String {
        switch self {
        case .FAIL:
            return "Please check the network and try again".localized()
        case .TIMEOUT:
            return "Please check the network and try again".localized()
        case .DECODEERROR:
            return "Please update to the latest version".localized()
        case .AUTHENTICATION(_):
            return "Please log in again".localized()
        case .NOTFOUND(_):
            return "Please update to the latest version".localized()
        case .CONFLICT(_):
            return "Please enter other information".localized()
        case .SERVERERROR(_):
            return "The server encountered an error. Please try again in a few minutes".localized()
        default:
            return "Please check the network and try again".localized()
        }
    }
}
