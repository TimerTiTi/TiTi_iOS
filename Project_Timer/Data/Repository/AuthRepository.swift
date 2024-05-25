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
    
    func signup(info: TestUserSignupInfo) -> AnyPublisher<AuthInfo, NetworkError> {
        return self.api.requestPublisher(.postSignup(info))
            .map(AuthResponse.self)
            .map { $0.toDomain() }
            .catchDecodeError()
    }
    
    func signin(info: TestUserSigninInfo) -> AnyPublisher<AuthInfo, NetworkError> {
        return self.api.requestPublisher(.postSignin(info))
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
    
    func checkEmailExit(username: String, email: String) -> AnyPublisher<Bool, NetworkError> {
        return self.api.requestPublisher(.getCheckEmail(username, email))
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
