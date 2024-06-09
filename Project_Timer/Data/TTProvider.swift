//
//  TTProvider.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2024/05/15.
//  Copyright © 2024 FDEE. All rights reserved.
//

import Foundation
import RxSwift
import Combine
import Moya

/// 공통적인 에러를 반환하는 Provider
final class TTProvider<T: TargetType>: MoyaProvider<T> {
    func request(_ token: T) -> AnyPublisher<Response, NetworkError> {
        return Future { promise in
            super.request(token) { result in
                switch result {
                case .success(let response):
                    if (200...299).contains(response.statusCode) {
                        promise(.success(response))
                    } else {
                        // ErrorResponse 디코딩
                        promise(.failure(NetworkError.errorResponse(response)))
                    }
                    promise(.success(response))
                case .failure(let error):
                    promise(.failure(self.handleError(error)))
                }
            }
        }
        .eraseToAnyPublisher()
    }

    private func handleError(_ error: Error) -> NetworkError {
        if let moyaError = error as? MoyaError {
            switch moyaError {
            case .statusCode(let response):
                return NetworkError.serverError(statusCode: response.statusCode)
            default:
                return NetworkError.FAIL
            }
        }
        return NetworkError.FAIL
    }
}

extension Publisher {
    /// Repository의 공통적인 Decode 에러를 반환하는 Publisher
    func catchDecodeError() -> AnyPublisher<Self.Output, NetworkError> {
        return self
            .mapError { _ in NetworkError.DECODEERROR }
            .eraseToAnyPublisher()
    }
}
