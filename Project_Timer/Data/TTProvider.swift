//
//  TTProvider.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2024/05/15.
//  Copyright © 2024 FDEE. All rights reserved.
//

import Foundation
import RxSwift
import Moya
import RxMoya

/// 공통적인 에러를 반환하는 Provider
final class TTProvider<T: TargetType>: MoyaProvider<T> {
    func request(_ token: T) -> Single<Response> {
        return super.rx.request(token)
            .catch { error in
                self.handleError(error)
            }
    }

    private func handleError(_ error: Error) -> Single<Response> {
        if let moyaError = error as? MoyaError {
            switch moyaError {
            case .statusCode(let response):
                return Single.error(NetworkError.serverError(statusCode: response.statusCode))
            default:
                return Single.error(NetworkError.FAIL)
            }
        }
        return Single.error(NetworkError.FAIL)
    }
}
