//
//  NetworkError.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2023/10/02.
//  Copyright © 2023 FDEE. All rights reserved.
//

import Foundation
import Moya

/// 네트워크 에러
enum NetworkError: Error {
    case fail
    case timeout
    case decode
    case client(String?) // 400
    case authentication(String?) // 401
    case notFound(String?) // 404
    case conflict(String?) // 409
    case server(String?) // 500
    case errorResponse(TTErrorResponse) // TiTi ErrorResponse
    
    static func serverError(statusCode: Int, data: Data? = nil) -> NetworkError {
        // MARK: Decoding 로직 필요
        let errorMessage: String? = ""
        switch statusCode {
        case 400:
            return .client(errorMessage)
        case 401:
            return .authentication(errorMessage)
        case 404:
            return .notFound(errorMessage)
        case 409:
            return .conflict(errorMessage)
        case 500:
            return .server(errorMessage)
        default:
            return .fail
        }
    }
    
    /// ErrorResponse 반환
    static func errorResponse(_ response: Response) -> NetworkError {
        guard let errorResponse = try? JSONDecoder().decode(TTErrorResponse.self, from: response.data) else {
            return .serverError(statusCode: response.statusCode)
        }
        return .errorResponse(errorResponse)
    }
    
    /// 범용적으로 표시될 수 있는 alert title 값, CLIENTERROR의 경우 VM에서 처리
    var title: String {
        switch self {
        case .fail:
            return Localized.string(.Server_Error_NetworkError)
        case .timeout:
            return Localized.string(.Server_Error_NetworkTimeout)
        case .decode:
            return Localized.string(.Server_Error_NetworkFetchError)
        case .authentication(_):
            return Localized.string(.SignIn_Error_AuthenticationError)
        case .notFound(_):
            return Localized.string(.Server_Error_NetworkFetchError)
        case .conflict(_):
            return Localized.string(.SignUp_Error_SignupError)
        case .server(_):
            return Localized.string(.Server_Error_ServerError)
        default:
            return Localized.string(.Server_Error_NetworkError)
        }
    }
    
    /// 범용적으로 표시될 수 있는 alert message 값, CLIENTERROR의 경우 VM에서 처리
    var message: String {
        switch self {
        case .fail:
            return Localized.string(.Server_Error_CheckNetwork)
        case .timeout:
            return Localized.string(.Server_Error_CheckNetwork)
        case .decode:
            return Localized.string(.Server_Error_DecodeError)
        case .authentication(_):
            return Localized.string(.SignIn_Error_SigninAgain)
        case .notFound(_):
            return Localized.string(.Server_Error_DecodeError)
        case .conflict(_):
            return Localized.string(.SignUp_Error_EnterDifferentValue)
        case .server(_):
            return Localized.string(.Server_Error_ServerErrorTryAgain)
        default:
            return Localized.string(.Server_Error_CheckNetwork)
        }
    }
    
    /// 범용적으로 표시되는 alert문구의 조합을 반환
    var alertMessage: (title: String, text: String) {
        return (title: self.title, text: self.message)
    }
}
