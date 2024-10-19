//
//  SignupNicknameModel.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2023/11/21.
//  Copyright © 2023 FDEE. All rights reserved.
//

import Foundation
import Combine
import SwiftUI

final class SignupNicknameModel: ObservableObject {
    
    // MARK: State
    
    @Published var contentWidth: CGFloat = .zero
    @Published var focus: TTSignupTextFieldView.type?
    @Published var validNickname: Bool?
    
    @Published var nickname: String = ""
    
    // MARK: Action
    
    enum Action {
        case checkNickname
    }
    
    public func action(_ action: Action) {
        switch action {
        case .checkNickname:
            self.checkNickname()
        }
    }
    
    // MARK: Properties
    
    let infos: SignupInfosForNickname
    
    // MARK: init
    
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
    
    // TODO: 추후 이용약관 동의 화면으로 진입 구현시 제거 필요
    var signupInfosForComplete: ChangeCompleteInfo {
        return ChangeCompleteInfo(
            title: "반가워요 \(self.nickname)!",
            subTitle: "계정 생성이 완료되었어요!",
            buttonTitle: "시작하기"
        )
    }
}

// MARK: Action
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
    func updateFocus(to focus: TTSignupTextFieldView.type?) {
        self.focus = focus
    }
    
    // nickname done 액션
    func checkNickname() {
        validNickname = PredicateChecker.isValidNickname(nickname)
    }
}
