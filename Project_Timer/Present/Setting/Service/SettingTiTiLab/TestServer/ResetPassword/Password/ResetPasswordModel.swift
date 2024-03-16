//
//  ResetPasswordModel.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2024/03/16.
//  Copyright © 2024 FDEE. All rights reserved.
//

import Foundation
import SwiftUI
import Combine

// MARK: State
final class ResetPasswordModel: ObservableObject {
    enum Stage {
        case password
        case password2
    }
    
    @Published var contentWidth: CGFloat = .zero
    @Published var focus: TTSignupTextFieldView.type?
    @Published var validPassword: Bool?
    @Published var validPassword2: Bool?
    @Published var stage: Stage = .password
    
    @Published var password: String = ""
    @Published var password2: String = ""
    
    let authUseCase: AuthUseCaseInterface
    private let infos: ResetPasswordInfosForPassword
    
    init(authUseCase: AuthUseCaseInterface, infos: ResetPasswordInfosForPassword) {
        self.authUseCase = authUseCase
        self.infos = infos
    }
    
    // passwordTextField underline 컬러
    var passwordTintColor: Color {
        if self.validPassword == false && self.password.isEmpty {
            return Colors.wrongTextField.toColor
        } else {
            return self.focus == .password ? Color.blue : UIColor.placeholderText.toColor
        }
    }
    
    // passwordTextField2 underline 컬러
    var password2TintColor: Color {
        if self.validPassword2 == false && self.password2.isEmpty {
            return Colors.wrongTextField.toColor
        } else {
            return self.focus == .password2 ? Color.blue : UIColor.placeholderText.toColor
        }
    }
}

// MARK: Action
extension ResetPasswordModel {
    // 화면크기에 따른 width 크기조정
    func updateContentWidth(size: CGSize) {
        switch size.deviceDetailType {
        case .iPhoneMini, .iPhonePro, .iPhoneMax:
            self.contentWidth = abs(size.minLength - 48)
        default:
            self.contentWidth = 400
        }
    }
    
    // @FocusState 값변화 -> stage 반영
    func updateFocus(to focus: TTSignupTextFieldView.type?) {
        self.focus = focus
        switch focus {
        case .password:
            self.resetPassword()
        case .password2:
            self.resetPassword2()
        default:
            return
        }
    }
    
    // password done 액션
    func checkPassword() {
        self.validPassword = PredicateChecker.isValidPassword(self.password)
        // stage 변화 -> @StateFocus 반영
        if self.validPassword == true {
            self.resetPassword2()
        } else {
            self.resetPassword()
        }
    }
    
    // password2 done 액션
    func checkPassword2() {
        let passwordValid = PredicateChecker.isValidPassword(self.password2)
        let samePassword = self.password == self.password2
        self.validPassword2 = (passwordValid && samePassword)
        // stage 변화 -> @StateFocus 반영
        if self.validPassword2 == false {
            self.resetPassword2()
        }
    }
    
    private func resetPassword() {
        self.validPassword2 = nil
        self.password = ""
        self.stage = .password
    }
    
    private func resetPassword2() {
        self.password2 = ""
        self.stage = .password2
    }
}
