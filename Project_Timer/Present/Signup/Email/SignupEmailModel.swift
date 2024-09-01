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
    enum Stage {
        case email
        case verificationCode
    }
    enum EmailStatus {
        case notValid
        case exist
        case networkError
        case notExist
    }
    
    let infos: SignupInfosForEmail
    var emailStatus: EmailStatus? {
        didSet {
            switch self.emailStatus {
            case .notValid, .exist, .networkError:
                self.isWarningEmail = true
            default:
                self.isWarningEmail = false
            }
        }
    }
    @Published var contentWidth: CGFloat = .zero
    @Published var focus: TTSignupTextFieldView.type?
    @Published var isWarningEmail: Bool = false
    @Published var validVerificationCode: Bool?
    @Published var getVerificationSuccess: Bool = false
    @Published var stage: Stage = .email
    
    @Published var email: String = ""
    @Published var verificationCode: String = ""
    private var verificationKey = ""
    
    private let getUsernameNotExistUseCase: GetUsernameNotExistUseCase
    private var cancellables = Set<AnyCancellable>()
    
    init(infos: SignupInfosForEmail, getUsernameNotExistUseCase: GetUsernameNotExistUseCase) {
        self.infos = infos
        self.getUsernameNotExistUseCase = getUsernameNotExistUseCase
        // vender email 정보를 기본값으로 설정
        if let email = infos.venderInfo?.email {
            self.email = email
        }
    }
    
    // emailTextField underline 컬러
    var emailTintColor: Color {
        switch self.emailStatus {
        case .notValid, .exist, .networkError:
            return Colors.wrongTextField.toColor
        default:
            return focus == .email ? Color.blue : UIColor.placeholderText.toColor
        }
    }
    
    // verificationCodeTextField underline 컬러
    var authCodeTintColor: Color {
        if validVerificationCode == false && verificationCode.isEmpty {
            return Colors.wrongTextField.toColor
        } else {
            return focus == .verificationCode ? Color.blue : UIColor.placeholderText.toColor
        }
    }
    
    // SignupInfosForPassword 생성 후 반환
    var infosForPassword: SignupInfosForPassword {
        return SignupInfosForPassword(
            type: self.infos.type,
            venderInfo: self.infos.venderInfo,
            emailInfo: SignupEmailInfo(
                email: self.email,
                verificationKey: self.verificationCode)
        )
    }
    
    // SignupInfosForNickname 생성 후 반환
    var infosForNickname: SignupInfosForNickname {
        return SignupInfosForNickname(
            type: self.infos.type,
            venderInfo: self.infos.venderInfo,
            emailInfo: SignupEmailInfo(
                email: self.email,
                verificationKey: self.verificationCode),
            passwordInfo: nil
        )
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
    func updateFocus(to focus: TTSignupTextFieldView.type?) {
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
        let validEmail = PredicateChecker.isValidEmail(email)
        // stage 변화 -> @FocusState 반영
        if validEmail == true {
            self.emailStatus = nil
            self.getUsernameNotExistUseCase.execute(username: email)
                .sink { [weak self] completion in
                    if case .failure(let networkError) = completion {
                        print("ERROR", #function, networkError)
                        self?.emailStatus = .networkError
                    }
                } receiveValue: { [weak self] checkUsernameInfo in
                    if checkUsernameInfo.isNotExist {
                        self?.emailStatus = .notExist
                        self?.resetVerificationCode()
                    } else {
                        print("DetailInfo", #function, checkUsernameInfo.detailInfo)
                        self?.emailStatus = .exist
                    }
                }
                .store(in: &self.cancellables)
        } else {
            self.emailStatus = .notValid
            self.resetEmail()
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
