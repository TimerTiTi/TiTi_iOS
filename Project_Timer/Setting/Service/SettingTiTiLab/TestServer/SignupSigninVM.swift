//
//  SignupSigninVM.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2023/09/27.
//  Copyright © 2023 FDEE. All rights reserved.
//

import Foundation
import Combine

final class SignupSigninVM {
    private let authUseCase: AuthUseCaseInterface
    let isSignin: Bool
    @Published var loadingText: String?
    @Published var alert: (title: String, text: String)?
    @Published var postable: Bool = false
    @Published var signinSuccess: Bool = false
    
    init(authUseCase: AuthUseCaseInterface = AuthUseCase(),
        isSignin: Bool) {
        self.authUseCase = authUseCase
        self.isSignin = isSignin
        
        self.checkServerURL()
    }
    
    private func checkServerURL() {
        NetworkURL.shared.updateServerURL { [weak self] in
            if NetworkURL.shared.serverURL == nil {
                self?.alert = (title: Localized.string(.Server_Popup_ServerCantUseTitle), text: Localized.string(.Server_Popup_ServerCantUseDesc))
            }
        }
    }
    
    func signup(info: TestUserSignupInfo) {
        self.loadingText = "Waiting for Signup..."
        self.authUseCase.signup(signupInfo: info) { [weak self] result in
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
    
    func signin(info: TestUserSigninInfo) {
        self.loadingText = "Waiting for Signin..."
        self.authUseCase.signin(signinInfo: info) { [weak self] result in
            self?.loadingText = nil
            switch result {
            case .success(let token):
                self?.saveUserInfo(username: info.username, password: info.password, token: token)
            case .failure(let error):
                switch error {
                    // signin 관련 error message 추가
                case .CLIENTERROR(_):
                    self?.alert = (title: "Signin Fail".localized(), text: "Please enter your nickname and password correctly".localized())
                    // TestServer 에러핸들링 이슈로 404코드 추가
                case .NOTFOUND(_):
                    self?.alert = (title: "Signin Fail".localized(), text: "Please enter your nickname and password correctly".localized())
                default:
                    self?.alert = error.alertMessage
                }
            }
        }
    }
    
    func check(nickname: String?, email: String?, password: String?) {
        if self.isSignin {
            self.postable = [nickname, password].allSatisfy({ $0 != nil && $0 != "" })
        } else {
            self.postable = [nickname, email, password].allSatisfy({ $0 != nil && $0 != "" })
        }
    }
    
    private func saveUserInfo(username: String, password: String, token: String) {
        // MARK: Token 저장, Noti signined
        guard [KeyChain.shared.save(key: .username, value: username),
               KeyChain.shared.save(key: .password, value: password),
               KeyChain.shared.save(key: .token, value: token)].allSatisfy({ $0 }) == true else {
            self.alert = (title: "Keychain save fail", text: "")
            return
        }
        
        UserDefaultsManager.set(to: true, forKey: .signinInTestServerV1)
        NotificationCenter.default.post(name: KeyChain.signined, object: nil)
        
        self.signinSuccess = true
    }
}
