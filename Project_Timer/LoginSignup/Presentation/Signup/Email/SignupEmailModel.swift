//
//  SignupEmailModel.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2023/10/29.
//  Copyright © 2023 FDEE. All rights reserved.
//

import Foundation
import Combine
import SwiftUI

typealias SignupSelectInfos = (type: SignupInfo.type, venderInfo: SignupVenderInfo?)

// MARK: State
class SignupEmailModel: ObservableObject {
    enum Stage {
        case email
        case verificationCode
    }
    
    let infos: SignupSelectInfos
    @Published var contentWidth: CGFloat = .zero
    @Published var focus: SignupTextFieldView.type?
    @Published var validEmail: Bool?
    @Published var validVerificationCode: Bool?
    @Published var getVerificationSuccess: Bool = false
    @Published var stage: Stage = .email
    
    @Published var email: String = ""
    @Published var verificationCode: String = ""
    private var verificationKey = ""
    
    init(infos: SignupSelectInfos) {
        self.infos = infos
        // vender email 정보를 기본값으로 설정
        if let email = infos.venderInfo?.email {
            self.email = email
        }
    }
    
    // emailTextField underline 컬러
    var emailTintColor: Color {
        if validEmail == false {
            return TiTiColor.wrongTextField.toColor
        } else {
            return focus == .email ? Color.blue : UIColor.placeholderText.toColor
        }
    }
    
    // verificationCodeTextField underline 컬러
    var authCodeTintColor: Color {
        if validVerificationCode == false && verificationCode.isEmpty {
            return TiTiColor.wrongTextField.toColor
        } else {
            return focus == .verificationCode ? Color.blue : UIColor.placeholderText.toColor
        }
    }
    
    // emailInfo 생성 후 반환
    var emailInfo: SignupEmailInfo {
        return SignupEmailInfo(email: email, verificationKey: verificationKey)
    }
}

// MARK: Action
extension SignupEmailModel {
    // 화면크기에 따른 width 크기조정
    func updateContentWidth(size: CGSize) {
        switch size.deviceDetailType {
        case .iPhoneMini, .iPhonePro, .iPhoneMax:
            contentWidth = abs(size.minLength - 48)
        default:
            contentWidth = 400
        }
    }
    
    // @FocusState 값변화 -> stage 반영
    func updateFocus(to focus: SignupTextFieldView.type?) {
        self.focus = focus
        switch focus {
        case .email:
            resetEmail()
        case .verificationCode:
            resetVerificationCode()
        default:
            return
        }
    }
    
    // email done 액션
    func checkEmail() {
        validEmail = PredicateChecker.isValidEmail(email)
        // stage 변화 -> @FocusState 반영
        if validEmail == true {
            resetVerificationCode()
        } else {
            resetEmail()
        }
    }
    
    // 인증코드 done 액션
    func checkVerificationCode() {
        validVerificationCode = verificationCode.count > 7
        // stage 변화 -> @StateFocus 반영
        if validVerificationCode == true {
            // verificationKey 수신 필요
            verificationKey = "abcd1234"
            getVerificationSuccess = true
        } else {
            resetVerificationCode()
        }
    }
    
    private func resetEmail() {
        validVerificationCode = nil
        stage = .email
    }
    
    private func resetVerificationCode() {
        verificationCode = ""
        stage = .verificationCode
    }
}
