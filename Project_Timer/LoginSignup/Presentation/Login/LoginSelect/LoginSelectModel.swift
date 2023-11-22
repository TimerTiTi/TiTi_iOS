//
//  LoginSelectModel.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2023/11/21.
//  Copyright © 2023 FDEE. All rights reserved.
//

import Foundation
import AuthenticationServices

class LoginSelectModel: ObservableObject & NSObject {
    @Published var contentWidth: CGFloat = .zero
    @Published var venderInfo: SignupVenderInfo?
    @Published var showAleret: Bool = false
    @Published var errorMessage: (title: String, text: String) = ("", "")
    private(set) var vender: SignupVenderInfo.vender?
    private(set) var authorizationCode: String?
}

// MARK: Action
extension LoginSelectModel {
    // 화면크기에 따른 width 크기조정
    func updateContentWidth(size: CGSize) {
        switch size.deviceDetailType {
        case .iPhoneMini:
            contentWidth = 300
        case .iPhonePro, .iPhoneMax:
            contentWidth = abs(size.minLength - 48)
        default:
            contentWidth = 400
        }
    }

    func googleLogin() {
        self.vender = .google
        // MARK: login 작업 필요
        self.venderInfo = SignupVenderInfo(
            vender: .google,
            id: "abcd1234",
            email: "freedeveloper97@gmail.com"
        )
    }
    
    var signupInfosForEmail: SignupInfosForEmail {
        return SignupInfosForEmail(
            type: self.venderInfo?.email != nil ? .vender : .venderWithEmail,
            venderInfo: self.venderInfo
        )
    }
}

extension LoginSelectModel {
    private func postLogin(vender: SignupVenderInfo.vender, authorizationCode: String, email: String?) {
        // MARK: server 전송 및 수신 필요
        // MARK: 회원가입 & 로그인 분기처리 필요
        let id = "abcd1234"
        let email = email ?? ""
        print(authorizationCode, email)
        
        self.venderInfo = SignupVenderInfo(
            vender: vender,
            id: id,
            email: email
        )
    }
}

// MARK: AppleLogin
extension LoginSelectModel: ASAuthorizationControllerDelegate {
    func performAppleSignIn() {
        let provider = ASAuthorizationAppleIDProvider()
        let request = provider.createRequest()
        request.requestedScopes = [.fullName, .email]
        let controller = ASAuthorizationController(authorizationRequests: [request])
        controller.delegate = self
        controller.performRequests()
    }
    
    func authorizationController(controller: ASAuthorizationController,
                                 didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            if let authorizationCode = appleIDCredential.authorizationCode {
                self.postLogin(
                    vender: .apple,
                    authorizationCode: String(data: authorizationCode, encoding: .utf8)!,
                    email: appleIDCredential.email
                )
            }
        } else {
            self.errorMessage = (title: "Apple Login Fail", text: "Please terminate the app and try again.")
            self.showAleret = true
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        self.errorMessage = (title: "Apple Login Fail", text: "Please terminate the app and try again.")
        self.showAleret = true
    }
}
