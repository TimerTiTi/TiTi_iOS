//
//  ResetPasswordNicknameModel.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2024/03/16.
//  Copyright © 2024 FDEE. All rights reserved.
//

import Foundation
import SwiftUI

// MARK: State
final class ResetPasswordNicknameModel: ObservableObject {
    @Published var contentWidth: CGFloat = .zero
    @Published var focus: TTSignupTextFieldView.type?
    @Published var validNickname: Bool?
    
    @Published var nickname: String = ""
    
    init() { }
    
    // nicknameTextField underline 컬러
    var nicknameTintColor: Color {
        if self.validNickname == false {
            return Colors.wrongTextField.toColor
        } else {
            return self.focus == .nickname ? Color.blue : UIColor.placeholderText.toColor
        }
    }
    
    // resetPasswordInfosForEmail 반환
    var resetPasswordInfosForEmail: ResetPasswordInfosForEmail {
        return ResetPasswordInfosForEmail(
            nickname: self.nickname
        )
    }
}

extension ResetPasswordNicknameModel {
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
    func updateFocus(to focus: TTSignupTextFieldView.type?) {
        self.focus = focus
    }
    
    // nickname done 액션
    func checkNickname() {
        self.validNickname = PredicateChecker.isValidNickname(nickname)
    }
}
