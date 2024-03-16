//
//  AuthRepository.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2023/12/15.
//  Copyright © 2023 FDEE. All rights reserved.
//

import Foundation

final class AuthRepository: AuthRepositoryInterface {
    private let api = AuthAPI()
    
    func signup(signupInfo: TestUserSignupInfo, completion: @escaping (Result<AuthInfo, NetworkError>) -> Void) {
        api.signup(signupInfo: signupInfo) { result in
            switch result.status {
            case .SUCCESS:
                guard let data = result.data,
                      let dto = try? JSONDecoder().decode(AuthDTO.self, from: data) else {
                    completion(.failure(.DECODEERROR))
                    return
                }
                
                let info = dto.toDomain()
                completion(.success(info))
                
            default:
                completion(.failure(.error(result)))
            }
        }
    }
    
    func signin(signinInfo: TestUserSigninInfo, completion: @escaping (Result<AuthInfo, NetworkError>) -> Void) {
        api.signin(signinInfo: signinInfo) { result in
            switch result.status {
            case .SUCCESS:
                guard let data = result.data,
                      let dto = try? JSONDecoder().decode(AuthDTO.self, from: data) else {
                    completion(.failure(.DECODEERROR))
                    return
                }
                
                let info = dto.toDomain()
                completion(.success(info))
                
            default:
                completion(.failure(.error(result)))
            }
        }
    }
    
    func checkUsername(username: String, completion: @escaping (Result<SimpleResponse, NetworkError>) -> Void) {
        api.checkUsername(username: username) { result in
            switch result.status {
            case .SUCCESS:
                guard let data = result.data,
                      let dto = try? JSONDecoder().decode(SimpleResponse.self, from: data) else {
                    completion(.failure(.DECODEERROR))
                    return
                }
                
                completion(.success(dto))
                
            default:
                completion(.failure(.error(result)))
            }
        }
    }
    
    func checkEmail(email: String, completion: @escaping (Result<SimpleResponse, NetworkError>) -> Void) {
        api.checkEmail(email: email) { result in
            switch result.status {
            case .SUCCESS:
                guard let data = result.data,
                      let dto = try? JSONDecoder().decode(SimpleResponse.self, from: data) else {
                    completion(.failure(.DECODEERROR))
                    return
                }
                
                completion(.success(dto))
                
            default:
                completion(.failure(.error(result)))
            }
        }
    }
    
    func updatePassword(request: ResetPasswordRequest, completion: @escaping (Result<SimpleResponse, NetworkError>) -> Void) {
        api.updatePassword(request: request) { result in
            switch result.status {
            case .SUCCESS:
                guard let data = result.data,
                      let dto = try? JSONDecoder().decode(SimpleResponse.self, from: data) else {
                    completion(.failure(.DECODEERROR))
                    return
                }
                
                completion(.success(dto))
                
            default:
                completion(.failure(.error(result)))
            }
        }
    }
}
