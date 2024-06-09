//
//  AuthNetwork.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2023/12/15.
//  Copyright © 2023 FDEE. All rights reserved.
//

import Foundation
import Moya

final class AuthNetwork {
    private let network = Network()
    private var signupURL: String {
        let base = NetworkURL.shared.serverURL ?? "nil"
        return base + "/auth/signup"
    }
    private var signinURL: String {
        let base = NetworkURL.shared.serverURL ?? "nil"
        return base + "/auth/login"
    }
    private var checkUsersURL: String {
        let base = NetworkURL.shared.serverURL ?? "nil"
        return base + "/auth/users"
    }
    private var resetPasswordURL: String {
        let base = NetworkURL.shared.serverURL ?? "nil"
        return base + "/auth/users/password"
    }
    
    func signup(signupInfo: TestUserSignupRequest, completion: @escaping (NetworkResult) -> Void) {
        self.network.request(url: self.signupURL, method: .post, param: nil, body: signupInfo) { result in
            completion(result)
        }
    }
    
    func signin(signinInfo: TestUserSigninRequest, completion: @escaping (NetworkResult) -> Void) {
        self.network.request(url: self.signinURL, method: .post, param: nil, body: signinInfo) { result in
            completion(result)
        }
    }
    
    func checkUsername(username: String, completion: @escaping (NetworkResult) -> Void) {
        self.network.request(url: self.checkUsersURL, method: .get, param: [
            "username": username
        ]) { result in
            completion(result)
        }
    }
    
    func checkEmail(username: String, email: String, completion: @escaping (NetworkResult) -> Void) {
        self.network.request(url: self.checkUsersURL, method: .get, param: [
            "username": username,
            "email": email
        ]) { result in
            completion(result)
        }
    }
    
    func updatePassword(request: ResetPasswordRequest, completion: @escaping (NetworkResult) -> Void) {
        self.network.request(url: self.resetPasswordURL, method: .post, body: request) { result in
            completion(result)
        }
    }
}
