//
//  UserRepository.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2024/09/01.
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
    
    func checkUsername(request: CheckUsernameRequest) -> AnyPublisher<CheckUsernameInfo, NetworkError> {
        return self.api.request(.checkUsername(request: request))
            .map(CheckUsernameResponse.self)
            .map { $0.toDomain() }
            .catchDecodeError()
    }
}
