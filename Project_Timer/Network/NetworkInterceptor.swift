//
//  NetworkInterceptor.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2022/12/25.
//  Copyright © 2022 FDEE. All rights reserved.
//

import Foundation
import Alamofire

final class NetworkInterceptor: RequestInterceptor {
    static let retryLimit = 3
    /// network request 전에 token 설정
    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
        guard urlRequest.url?.absoluteString.hasPrefix(NetworkURL.TestServer.base) == true else {
            completion(.success(urlRequest))
            return
        }
        
        guard let token = KeyChain.shared.get(key: .token) else {
            completion(.success(urlRequest))
            return
        }
        
        var urlRequest = urlRequest
        urlRequest.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        completion(.success(urlRequest))
    }
    
    /// token 만료인 경우 login 하여 token 발급 후 재시도
    func retry(_ request: Request, for session: Session, dueTo error: Error, completion: @escaping (RetryResult) -> Void) {
        guard request.retryCount < Self.retryLimit else {
            completion(.doNotRetry)
            return
        }
        guard let response = request.task?.response as? HTTPURLResponse,
              response.statusCode == 401 else {
            completion(.doNotRetryWithError(error))
            return
        }
        print("***token 만료, retry 로직 진행")
        // login -> get new token
        self.loginForToken { token in
            guard let token = token else {
                completion(.doNotRetryWithError(error))
                return
            }
            
            if KeyChain.shared.update(key: .token, value: token) {
                print("***token 재발급 완료")
                completion(.retry)
            } else {
                print("***token 재발급 실패")
                completion(.doNotRetryWithError(error))
            }
        }
    }
}

extension NetworkInterceptor {
    private func loginForToken(completion: @escaping (String?) -> Void) {
        guard let username = KeyChain.shared.get(key: .username),
              let password = KeyChain.shared.get(key: .password) else { return }
        let loginInfo = TestUserLoginInfo(username: username, password: password)
        let network: TestServerAuthFetchable = NetworkController(network: Network())
        network.login(userInfo: loginInfo) { status, token in
            guard status == .SUCCESS, let token = token else {
                completion(nil)
                return
            }
            completion(token)
        }
    }
}
