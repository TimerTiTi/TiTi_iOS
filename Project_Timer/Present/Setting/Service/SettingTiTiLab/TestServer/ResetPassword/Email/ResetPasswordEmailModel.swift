//
//  ResetPasswordEmailModel.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2024/03/16.
//  Copyright © 2024 FDEE. All rights reserved.
//

import Foundation
import SwiftUI

// MARK: State
final class ResetPasswordEmailModel: ObservableObject {
    enum ErrorMessage {
        case notExist
        case serverError
        
        var message: String {
            switch self {
            case .notExist:
                return Localized.string(.FindAccount_Error_NotRegisteredEmail)
            case .serverError:
                return Localized.string(.Server_Error_CheckNetwork)
            }
        }
    }
    @Published var contentWidth: CGFloat = .zero
    @Published var focus: TTSignupTextFieldView.type?
    @Published var validEmail: Bool?
    @Published var errorMessage: ErrorMessage?
    
    @Published var email: String = ""
    
    let authUseCase: AuthUseCaseInterface
    private let infos: ResetPasswordInfosForEmail
    
    init(authUseCase: AuthUseCaseInterface, infos: ResetPasswordInfosForEmail) {
        self.authUseCase = authUseCase
        self.infos = infos
    }
    
    var emailWarningVisible: Bool {
        return self.validEmail == false
    }
    
    // nicknameTextField underline 컬러
    var emailTintColor: Color {
        if self.emailWarningVisible {
            return Colors.wrongTextField.toColor
        } else {
            return self.focus == .email ? Color.blue : UIColor.placeholderText.toColor
        }
    }
    
    // resetPasswordInfosForEmail 반환
    var resetPasswordInfosForPassword: ResetPasswordInfosForPassword {
        return ResetPasswordInfosForPassword(
            nickname: self.infos.nickname,
            email: self.email
        )
    }
}

extension ResetPasswordEmailModel {
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
    
    // email done 액션
    func checkEmail() {
        self.authUseCase.checkEmail(username: self.infos.nickname, email: self.email) { [weak self] result in
            switch result {
            case .success(let simpleResponse):
                self?.validEmail = simpleResponse.data
            case .failure(let error):
                self?.validEmail = false
                switch error {
                case .NOTFOUND(_):
                    self?.errorMessage = .notExist
                default:
                    self?.errorMessage = .serverError
                    print("Error: \(error.title), \(error.message)")
                }
            }
        }
    }
}
