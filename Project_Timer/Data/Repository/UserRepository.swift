//
//  UserRepository.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2024/10/20.
//  Copyright © 2024 FDEE. All rights reserved.
//

import Foundation
import Moya
import Combine
import CombineMoya

final class UserRepository {
    private let api: TTProvider<UserAPI>
    
    init(api: TTProvider<UserAPI>) {
        self.api = api
    }
    
    func register(request: SignupRequest) -> AnyPublisher<TTResponseInfo, NetworkError> {
        return self.api.request(.register(request: request))
            .map(TTResponse.self)
            .map { .init(
                code: $0.code,
                message: $0.message,
                isSuccess: true
            ) }
            .catchDecodeError()
    }
}
