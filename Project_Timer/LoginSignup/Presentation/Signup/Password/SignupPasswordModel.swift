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

typealias SignupEmailInfos = (prevInfos: SignupSelectInfos, emailInfo: SignupEmailInfo)

class SignupPasswordModel: ObservableObject {
    let infos: SignupEmailInfos
    @Published var contentWidth: CGFloat = .zero
    @Published var focus: SignupTextFieldView.type?
    @Published var wrongPassword: Bool?
    @Published var wrongPassword2: Bool?
    @Published var passwordSuccess: Bool = false
    
    @Published var password: String = ""
    @Published var password2: String = ""
    
    init(infos: SignupEmailInfos) {
        self.infos = infos
    }
    
    // passwordTextField underline 컬러
    var passwordTintColor: Color {
        if wrongPassword == true {
            return TiTiColor.wrongTextField.toColor
        } else {
            return focus == .password ? Color.blue : UIColor.placeholderText.toColor
        }
    }
    
    var password2TintColor: Color {
        if wrongPassword2 == true {
            return TiTiColor.wrongTextField.toColor
        } else {
            return focus == .password2 ? Color.blue : UIColor.placeholderText.toColor
        }
    }
    
    // passwordInfo 생성 후 반환
    var passwordInfo: SignupPasswordInfo {
        return SignupPasswordInfo(password: password)
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
    
    // focusState 값변화 수신
    func updateFocus(to focus: SignupTextFieldView.type?) {
        self.focus = focus
    }
    
    func checkPassword() {
        let passwordValid = PredicateChecker.isValidPassword(password)
        wrongPassword = !passwordValid
    }
    
    func checkPassword2() {
        let passwordValid = PredicateChecker.isValidPassword(password2)
        let samePassword = password == password2
        wrongPassword2 = !(passwordValid && samePassword)
        passwordSuccess = passwordValid && samePassword
    }
}
