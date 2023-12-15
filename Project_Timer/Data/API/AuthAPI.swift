//
//  AuthAPI.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2023/12/15.
//  Copyright © 2023 FDEE. All rights reserved.
//

import Foundation

final class AuthAPI {
    private let network = Network()
    private var signupURL: String {
        let base = NetworkURL.shared.serverURL ?? "nil"
        return base + "/auth/signup"
    }
    private var signinURL: String {
        let base = NetworkURL.shared.serverURL ?? "nil"
        return base + "/auth/login"
    }
    
    func signup(signupInfo: TestUserSignupInfo, completion: @escaping (NetworkResult) -> Void) {
        self.network.request(url: signupURL, method: .post, param: nil, body: signupInfo) { result in
            completion(result)
        }
    }
    
    func signin(signinInfo: TestUserSigninInfo, completion: @escaping (NetworkResult) -> Void) {
        self.network.request(url: signinURL, method: .post, param: nil, body: signinInfo) { result in
            completion(result)
        }
    }
}
