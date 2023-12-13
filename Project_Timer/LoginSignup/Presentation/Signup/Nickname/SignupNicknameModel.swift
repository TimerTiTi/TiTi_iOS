//
//  SignupNicknameModel.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2023/11/21.
//  Copyright © 2023 FDEE. All rights reserved.
//

import Foundation
import SwiftUI

// MARK: State
class SignupNicknameModel: ObservableObject {
    let infos: SignupInfosForNickname
    @Published var contentWidth: CGFloat = .zero
    @Published var focus: SignupTextFieldView.type?
    @Published var validNickname: Bool?
    
    @Published var nickname: String = ""
    
    init(infos: SignupInfosForNickname) {
        self.infos = infos
    }
    
    // nicknameTextField underline 컬러
    var nicknameTintColor: Color {
        if validNickname == false {
            return Colors.wrongTextField.toColor
        } else {
            return focus == .nickname ? Color.blue : UIColor.placeholderText.toColor
        }
    }
    
    // signupInfosForTermOfUse 반환
    var signupInfosForTermOfUse: SignupInfosForTermOfUse {
        return SignupInfosForTermOfUse(
            type: self.infos.type,
            venderInfo: self.infos.venderInfo,
            emailInfo: self.infos.emailInfo,
            passwordInfo: self.infos.passwordInfo,
            nicknameInfo: SignupNicknameInfo(nickname: self.nickname)
        )
    }
}

extension SignupNicknameModel {
    // 화면크기에 따른 width 크기조정
    func updateContentWidth(size: CGSize) {
        switch size.deviceDetailType {
        case .iPhoneMini, .iPhonePro, .iPhoneMax:
            contentWidth = abs(size.minLength - 48)
        default:
            contentWidth = 400
        }
    }
    
    // @FocusState 값변화 반영
    func updateFocus(to focus: SignupTextFieldView.type?) {
        self.focus = focus
    }
    
    // nickname done 액션
    func checkNickname() {
        validNickname = PredicateChecker.isValidNickname(nickname)
    }
}
