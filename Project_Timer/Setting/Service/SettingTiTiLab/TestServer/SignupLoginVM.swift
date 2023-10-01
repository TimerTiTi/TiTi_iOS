//
//  SignupLoginVM.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2023/09/27.
//  Copyright © 2023 FDEE. All rights reserved.
//

import Foundation
import Combine

final class SignupLoginVM {
    let isLogin: Bool
    let network: TestServerAuthFetchable
    @Published var loadingText: String?
    @Published var alert: (title: String, text: String)?
    @Published var loginSuccess: Bool = false
    
    init(isLogin: Bool, network: TestServerAuthFetchable) {
        self.isLogin = isLogin
        self.network = network
    }
    
    func signup(info: TestUserSignupInfo) {
        self.loadingText = "Waiting for Signup..."
        self.network.signup(userInfo: info) { [weak self] status, token in
            self?.loadingText = nil
            switch status {
            case .SUCCESS:
                guard let token = token else {
                    self?.alert = (title: "Network Error", text: "invalid token value")
                    return
                }
                self?.saveUserInfo(username: info.username, password: info.password, token: token)
            case .CONFLICT:
                self?.alert = (title: "CONFLICT", text: "need another infos")
            default:
                self?.alert = (title: "FAIL", text: "\(status.rawValue)")
            }
        }
    }
    
    func login(info: TestUserLoginInfo) {
        self.loadingText = "Waiting for Login..."
        self.network.login(userInfo: info) { [weak self] status, token in
            self?.loadingText = nil
            switch status {
            case .SUCCESS:
                guard let token = token else {
                    self?.alert = (title: "Network Error", text: "invalid token value")
                    return
                }
                self?.saveUserInfo(username: info.username, password: info.password, token: token)
            default:
                self?.alert = (title: "FAIL", text: "\(status.rawValue)")
            }
        }
    }
    
    private func saveUserInfo(username: String, password: String, token: String) {
        // MARK: Token 저장, Noti logined
        guard [KeyChain.shared.save(key: .username, value: username),
               KeyChain.shared.save(key: .password, value: password),
               KeyChain.shared.save(key: .token, value: token)].allSatisfy({ $0 }) == true else {
            self.alert = (title: "Keychain save fail", text: "")
            return
        }
        
        UserDefaultsManager.set(to: true, forKey: .loginInTestServerV1)
        NotificationCenter.default.post(name: KeyChain.logined, object: nil)
        
        self.loginSuccess = true
    }
}
