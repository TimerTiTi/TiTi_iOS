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
                    let url = "[\(token.method.rawValue)] \(response.response?.url?.absoluteString ?? "No URL")"
                    let requestBody = response.request?.httpBody.flatMap { String(data: $0, encoding: .utf8) }
                    let responseBody = String(data: response.data, encoding: .utf8)
                    
                    let debugInfo = """
                                ✅ TTProvider success
                                ================================================
                                1️⃣ moya: \(token)
                                2️⃣ URL: \(url)
                                3️⃣ Request Body: \(requestBody ?? "nil")
                                4️⃣ Response Body: \(responseBody ?? "nil")
                                ================================================
                                """
                    print(debugInfo)
                    
                    if (200...299).contains(response.statusCode) {
                        promise(.success(response))
                    } else {
                        // ErrorResponse 디코딩
                        promise(.failure(NetworkError.errorResponse(response)))
                    }
                    promise(.success(response))
                case .failure(let error):
                    let url = "[\(token.method.rawValue)] \(token.baseURL)\(token.path), \(token.queryParameters ?? [:])"
                    
                    let debugInfo = """
                                🚨 TTProvider failure
                                ================================================
                                1️⃣ moya: \(token)
                                2️⃣ URL: \(url)
                                3️⃣ errorCode: \(error.errorCode)
                                4️⃣ errorDescription: \(error.localizedDescription)
                                ================================================
                                """
                    print(debugInfo)
                    
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
            .mapError { error in return error as? NetworkError ?? .DECODEERROR }
            .eraseToAnyPublisher()
    }
}

extension Publisher where Output == Response, Failure == NetworkError {
    /// TTProvider를 사용한 경우 map operator 사용
    func map<D: Decodable>(_ type: D.Type) -> AnyPublisher<D, NetworkError> {
        return self.tryMap { response in
            do {
                let jsonDecoder = JSONDecoder()
                jsonDecoder.dateDecodingStrategy = .iso8601
                let decodedData = try jsonDecoder.decode(D.self, from: response.data)
                return decodedData
            } catch {
                throw NetworkError.DECODEERROR
            }
        }
        .mapError { error in
            error as? NetworkError ?? NetworkError.FAIL
        }
        .eraseToAnyPublisher()
    }
}
