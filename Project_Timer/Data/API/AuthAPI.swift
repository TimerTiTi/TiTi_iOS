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
    
    func signup(completion: @escaping (NetworkResult) -> Void) {
        self.network.request(url: signupURL, method: .get) { result in
            completion(result)
        }
    }
    
    func signin(completion: @escaping (NetworkResult) -> Void) {
        self.network.request(url: signinURL, method: .get) { result in
            completion(result)
        }
    }
}
