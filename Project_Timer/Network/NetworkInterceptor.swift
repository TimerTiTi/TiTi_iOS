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
    /// network request 전에 token 설정
    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
        guard let token = KeyChain.shared.get(key: .token) else {
            completion(.success(urlRequest))
            return
        }
        
        guard urlRequest.url?.absoluteString.hasPrefix(NetworkURL.TestServer.base) == true else {
            completion(.success(urlRequest))
            return
        }
        
        var urlRequest = urlRequest
        urlRequest.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        completion(.success(urlRequest))
    }
    
    /// token 만료인 경우 login 하여 token 발급 후 재시도
//    func retry(_ request: Request, for session: Session, dueTo error: Error, completion: @escaping (RetryResult) -> Void) {
//        //
//    }
}
