//
//  SigninSelectModel.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2023/11/21.
//  Copyright © 2023 FDEE. All rights reserved.
//

import Foundation
import AuthenticationServices
import GoogleSignIn

class SigninSelectModel: ObservableObject & NSObject {
    @Published var contentWidth: CGFloat = .zero
    @Published var venderInfo: SignupVenderInfo?
    @Published var showAleret: Bool = false
    @Published var errorMessage: (title: String, text: String) = ("", "")
    private(set) var vender: SignupVenderInfo.vender?
    private(set) var authorizationCode: String?
}

// MARK: Action
extension SigninSelectModel {
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
    
    var signupInfosForEmail: SignupInfosForEmail {
        return SignupInfosForEmail(
            type: self.venderInfo?.email != nil ? .vender : .venderWithEmail,
            venderInfo: self.venderInfo
        )
    }
}

extension SigninSelectModel {
    private func postSignin(vender: SignupVenderInfo.vender, authorizationCode: String, email: String?) {
        // MARK: server 전송 및 수신 필요
        // MARK: 회원가입 & 로그인 분기처리 필요
        let id = "abcd1234"
        let email = email ?? ""
        
        self.venderInfo = SignupVenderInfo(
            vender: vender,
            id: id,
            email: email
        )
    }
}

// MARK: AppleSignIn
extension SigninSelectModel: ASAuthorizationControllerDelegate {
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
                self.postSignin(
                    vender: .apple,
                    authorizationCode: String(data: authorizationCode, encoding: .utf8)!,
                    email: appleIDCredential.email
                )
            }
        } else {
            self.errorMessage = (title: Localized.string(.SignIn_Error_SocialSignInFail), text: Localized.string(.SignIn_Error_SocialSignInFailDomain, op: "Apple"))
            self.showAleret = true
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        self.errorMessage = (title: Localized.string(.SignIn_Error_SocialSignInFail), text: Localized.string(.SignIn_Error_SocialSignInFailDomain, op: "Apple"))
        self.showAleret = true
        print(error.localizedDescription)
    }
}

// MARK: GoogleSignIn
extension SigninSelectModel {
    func performGoogleSignIn(rootVC: UIViewController?) {
        guard let rootVC = rootVC else { return }
        GIDSignIn.sharedInstance.signIn(withPresenting: rootVC) { signInResult, error in
            guard let result = signInResult, error == nil else {
                self.errorMessage = (title: Localized.string(.SignIn_Error_SocialSignInFail), text: Localized.string(.SignIn_Error_SocialSignInFailDomain, op: "Google"))
                self.showAleret = true
                print(error?.localizedDescription)
                return
            }
            
            let email = result.user.profile?.email ?? ""
            if let authorizationCode = signInResult?.serverAuthCode {
                self.postSignin(
                    vender: .google,
                    authorizationCode: authorizationCode,
                    email: email
                )
            }
        }
    }
}
