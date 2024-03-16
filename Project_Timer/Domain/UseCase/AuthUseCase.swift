//
//  AuthUseCase.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2023/12/15.
//  Copyright © 2023 FDEE. All rights reserved.
//

import Foundation

final class AuthUseCase: AuthUseCaseInterface {
    let repository: AuthRepositoryInterface
    
    init(repository: AuthRepositoryInterface) {
        self.repository = repository
    }
    
    func signup(signupInfo: TestUserSignupInfo, completion: @escaping (Result<String, NetworkError>) -> Void) {
        self.repository.signup(signupInfo: signupInfo) { result in
            // AuthInfo -> token 값반 반환
            switch result {
            case .success(let authInfo):
                completion(.success(authInfo.token))
            case .failure(let networkError):
                completion(.failure(networkError))
            }
        }
    }
    
    func signin(signinInfo: TestUserSigninInfo, completion: @escaping (Result<String, NetworkError>) -> Void) {
        self.repository.signin(signinInfo: signinInfo) { result in
            // AuthInfo -> token 값반 반환
            switch result {
            case .success(let authInfo):
                completion(.success(authInfo.token))
            case .failure(let networkError):
                completion(.failure(networkError))
            }
        }
    }
    
    func checkUsername(username: String, completion: @escaping (Result<SimpleResponse, NetworkError>) -> Void) {
        self.repository.checkUsername(username: username) { result in
            switch result {
            case .success(let simpleResponse):
                completion(.success(simpleResponse))
            case .failure(let networkError):
                completion(.failure(networkError))
            }
        }
    }
    
    func checkEmail(email: String, completion: @escaping (Result<SimpleResponse, NetworkError>) -> Void) {
        self.repository.checkEmail(email: email) { result in
            switch result {
            case .success(let simpleResponse):
                completion(.success(simpleResponse))
            case .failure(let networkError):
                completion(.failure(networkError))
            }
        }
    }
    
    func updatePassword(request: ResetPasswordRequest, completion: @escaping (Result<SimpleResponse, NetworkError>) -> Void) {
        self.repository.updatePassword(request: request) { result in
            switch result {
            case .success(let simpleResponse):
                completion(.success(simpleResponse))
            case .failure(let networkError):
                completion(.failure(networkError))
            }
        }
    }
}
