//
//  SignupPasswordModel.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2023/10/30.
//  Copyright © 2023 FDEE. All rights reserved.
//

import Foundation
import SwiftUI
import Combine

// MARK: State
class SignupPasswordModel: ObservableObject {
    enum Stage {
        case password
        case password2
    }
    
    let infos: SignupInfosForPassword
    @Published var contentWidth: CGFloat = .zero
    @Published var focus: SignupTextFieldView.type?
    @Published var validPassword: Bool?
    @Published var validPassword2: Bool?
    @Published var stage: Stage = .password
    
    @Published var password: String = ""
    @Published var password2: String = ""
    
    init(infos: SignupInfosForPassword) {
        self.infos = infos
    }
    
    // passwordTextField underline 컬러
    var passwordTintColor: Color {
        if validPassword == false && password.isEmpty {
            return TiTiColor.wrongTextField.toColor
        } else {
            return focus == .password ? Color.blue : UIColor.placeholderText.toColor
        }
    }
    
    // passwordTextField2 underline 컬러
    var password2TintColor: Color {
        if validPassword2 == false && password2.isEmpty {
            return TiTiColor.wrongTextField.toColor
        } else {
            return focus == .password2 ? Color.blue : UIColor.placeholderText.toColor
        }
    }
}

// MARK: Action
extension SignupPasswordModel {
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
        case .password:
            resetPassword()
        case .password2:
            resetPassword2()
        default:
            return
        }
    }
    
    // password done 액션
    func checkPassword() {
        validPassword = PredicateChecker.isValidPassword(password)
        // stage 변화 -> @StateFocus 반영
        if validPassword == true {
            resetPassword2()
        } else {
            resetPassword()
        }
    }
    
    // password2 done 액션
    func checkPassword2() {
        let passwordValid = PredicateChecker.isValidPassword(password2)
        let samePassword = password == password2
        validPassword2 = (passwordValid && samePassword)
        // stage 변화 -> @StateFocus 반영
        if validPassword2 == false {
            resetPassword2()
        }
    }
    
    private func resetPassword() {
        validPassword2 = nil
        password = ""
        stage = .password
    }
    
    private func resetPassword2() {
        password2 = ""
        stage = .password2
    }
}
