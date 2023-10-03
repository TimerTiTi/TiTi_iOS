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
    @Published var postable: Bool = false
    @Published var loginSuccess: Bool = false
    
    init(isLogin: Bool, network: TestServerAuthFetchable) {
        self.isLogin = isLogin
        self.network = network
    }
    
    func signup(info: TestUserSignupInfo) {
        self.loadingText = "Waiting for Signup..."
        self.network.signup(userInfo: info) { [weak self] result in
            self?.loadingText = nil
            switch result {
            case .success(let token):
                self?.saveUserInfo(username: info.username, password: info.password, token: token)
            case .failure(let error):
                switch error {
                    // signup 관련 error message 추가
                case .CLIENTERROR(_):
                    self?.alert = (title: "Signup Error".localized(), text: "Please check your nickname or email (at least 5 characters)".localized())
                default:
                    self?.alert = error.alertMessage
                }
            }
        }
    }
    
    func login(info: TestUserLoginInfo) {
        self.loadingText = "Waiting for Login..."
        self.network.login(userInfo: info) { [weak self] result in
            self?.loadingText = nil
            switch result {
            case .success(let token):
                self?.saveUserInfo(username: info.username, password: info.password, token: token)
            case .failure(let error):
                switch error {
                    // login 관련 error message 추가
                case .CLIENTERROR(_):
                    self?.alert = (title: "Login Fail".localized(), text: "Please enter your nickname and password correctly".localized())
                default:
                    self?.alert = error.alertMessage
                }
            }
        }
    }
    
    func check(nickname: String?, email: String?, password: String?) {
        if self.isLogin {
            self.postable = [nickname, password].allSatisfy({ $0 != nil && $0 != "" })
        } else {
            self.postable = [nickname, email, password].allSatisfy({ $0 != nil && $0 != "" })
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
