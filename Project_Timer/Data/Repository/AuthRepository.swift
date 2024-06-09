//
//  AuthRepository.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2024/05/22.
//  Copyright © 2024 FDEE. All rights reserved.
//

import Foundation
import Moya
import Combine
import CombineMoya

final class AuthRepository {
    private let api: TTProvider<AuthAPI>
    
    init(api: TTProvider<AuthAPI>) {
        self.api = api
    }
    
    func signup(request: TestUserSignupRequest) -> AnyPublisher<AuthInfo, NetworkError> {
        return self.api.requestPublisher(.postSignup(request))
            .map(AuthResponse.self)
            .map { $0.toDomain() }
            .catchDecodeError()
    }
    
    func signin(request: TestUserSigninRequest) -> AnyPublisher<AuthInfo, NetworkError> {
        return self.api.requestPublisher(.postSignin(request))
            .map(AuthResponse.self)
            .map { $0.toDomain() }
            .catchDecodeError()
    }
    
    func checkUsernameExit(username: String) -> AnyPublisher<Bool, NetworkError> {
        return self.api.requestPublisher(.getCheckUsername(username))
            .map(SimpleResponse.self)
            .map { $0.toDomain() }
            .catchDecodeError()
    }
    
    func checkEmailExit(request: CheckEmailExitRequest) -> AnyPublisher<Bool, NetworkError> {
        return self.api.requestPublisher(.getCheckEmail(request))
            .map(SimpleResponse.self)
            .map { $0.toDomain() }
            .catchDecodeError()
    }
    
    func updatePassword(request: ResetPasswordRequest) -> AnyPublisher<Bool, NetworkError> {
        return self.api.requestPublisher(.postUpdatePassword(request))
            .map(SimpleResponse.self)
            .map { $0.toDomain() }
            .catchDecodeError()
    }
}
