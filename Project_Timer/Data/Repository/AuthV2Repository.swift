//
//  AuthV2Repository.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2024/09/29.
//  Copyright © 2024 FDEE. All rights reserved.
//

import Foundation
import Moya
import Combine
import CombineMoya

final class AuthV2Repository {
    private let api: TTProvider<AuthV2API>
    
    init(api: TTProvider<AuthV2API>) {
        self.api = api
    }
    
    func postAuthcode(request: PostAuthCodeRequest) -> AnyPublisher<PostAuthCodeInfo, NetworkError> {
        return self.api.request(.postAuthcode(request: request))
            .map(PostAuthCodeResponse.self)
            .map { $0.toDomain() }
            .catchDecodeError()
    }
    
    func verifyAuthCode(request: VerifyAuthCodeRequest) -> AnyPublisher<VerifyAuthCodeInfo, NetworkError> {
        return self.api.request(.verifyAuthcode(request: request))
            .map(VerifyAuthCodeResponse.self)
            .map { $0.toDomain() }
            .catchDecodeError()
    }
}
