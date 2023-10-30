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

// MARK: State
class SignupEmailModel: ObservableObject {
    @Published var contentWidth: CGFloat = .zero
    @Published var focus: SignupTextFieldView.type?
    @Published var authCode: String = ""
    @Published var wrongEmail: Bool?
    @Published var wrongAuthCode: Bool?
    
    // emailTextField underline 컬러
    var emailTintColor: Color {
        if wrongEmail == true {
            return TiTiColor.wrongTextField.toColor
        } else if focus == .email {
            return Color.blue
        } else {
            return UIColor.placeholderText.toColor
        }
    }
    
    // authCodeTextField underline 컬러
    var authCodeTintColor: Color {
        if wrongAuthCode == true {
            return TiTiColor.wrongTextField.toColor
        } else if focus == .authCode {
            return Color.blue
        } else {
            return UIColor.placeholderText.toColor
        }
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
    
    // focusState 값변화 수신
    func updateFocus(to focus: SignupTextFieldView.type?) {
        self.focus = focus
    }
    
    // 이메일 done 액션
    func emailCheck(_ email: String) {
        let emailValid = PredicateChecker.isValidEmail(email)
        wrongEmail = !emailValid
    }
    
    // 인증코드 done 액션
    func authCodeCheck() {
        let authCodeValid = authCode.count > 7
        wrongAuthCode = !authCodeValid
    }
}
