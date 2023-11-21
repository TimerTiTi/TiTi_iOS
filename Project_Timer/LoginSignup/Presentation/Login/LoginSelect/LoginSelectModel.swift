//
//  LoginSelectModel.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2023/11/21.
//  Copyright © 2023 FDEE. All rights reserved.
//

import Foundation

class LoginSelectModel: ObservableObject {
    @Published var contentWidth: CGFloat = .zero
    @Published var venderInfo: SignupVenderInfo?
    private(set) var vender: SignupVenderInfo.vender?
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
    
    func appleLogin() {
        self.vender = .apple
        // MARK: login 작업 필요
        self.venderInfo = SignupVenderInfo(
            vender: .apple,
            id: "abcd1234",
            email: "freedeveloper97@gmail.com"
        )
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
