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

final class SignupEmailModel: ObservableObject {
    
    // MARK: State
    
    @Published var contentWidth: CGFloat = .zero
    @Published var focus: TTSignupTextFieldView.type?
    @Published var isWarningEmail: Bool = false
    @Published var isWarningAuthCode: Bool = false
    @Published var validVerificationCode: Bool?
    @Published var getVerificationSuccess: Bool = false
    @Published var stage: Stage = .email
    @Published var alert: (title: String, text: String)?
    
    @Published var email: String = "" // 이메일 TextField 값
    @Published var authCode: String = "" // 인증코드 TextField 값
    @Published var authCodeRemainSeconds: Int? // authCode 만료까지 남은 초
    
    // MARK: Action
    
    enum Action {
        case resendAuthCode
        case verifyAuthCode
    }
    
    public func action(_ action: Action) {
        switch action {
        case .resendAuthCode:
            self.postAuthCode()
        case .verifyAuthCode:
            self.verifyAuthCode()
        }
    }
    
    // MARK: Properties
    
    enum Stage {
        case email
        case verificationCode
    }
    enum EmailStatus {
        case notValid
        case exist
        case notExist
        
        var errorMessage: String {
            switch self {
            case .notValid: return Localized.string(.SignUp_Error_WrongEmailFormat)
            case .exist: return Localized.string(.SignUp_Error_DuplicateEmailInProcess)
            case .notExist: return ""
            }
        }
    }
    enum AuthCodeStatus {
        case verified
        case expired
        case invalied
        
        var errorMessage: String {
            switch self {
            case .expired: return Localized.string(.SignUp_Error_CodeExpired)
            case .invalied: return Localized.string(.SignUp_Error_WrongCode)
            case .verified: return ""
            }
        }
    }
    
    let infos: SignupInfosForEmail
    var emailStatus: EmailStatus? {
        didSet {
            switch self.emailStatus {
            case .notValid, .exist:
                self.isWarningEmail = true
            default:
                self.isWarningEmail = false
            }
        }
    }
    var authCodeStatus: AuthCodeStatus? {
        didSet {
            switch self.authCodeStatus {
            case .expired, .invalied:
                self.isWarningAuthCode = true
            default:
                self.isWarningAuthCode = false
            }
        }
    }
    private var postAuthCodeTerminateDate: Date? // authCode 만료 시점
    private var authKey: String? // authCode 전송시 서버로부터 받은 5분간 유효한 authKey
    private var authToken: String? // authCode 검증 성공시 서버로부터 받은 30분간 유효한 authToken
    private var timer: Timer? // authCode 전송 후 남은 시간, 1초간 업데이트
    
    private let getUsernameNotExistUseCase: GetUsernameNotExistUseCase
    private let postAuthCodeUseCase: PostAuthCodeUseCase
    private let verifyAuthCodeUseCase: VerifyAuthCodeUseCase
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: init
    
    init(
        infos: SignupInfosForEmail,
        getUsernameNotExistUseCase: GetUsernameNotExistUseCase,
        postAuthCodeUseCase: PostAuthCodeUseCase,
        verifyAuthCodeUseCase: VerifyAuthCodeUseCase
    ) {
        self.infos = infos
        self.getUsernameNotExistUseCase = getUsernameNotExistUseCase
        self.postAuthCodeUseCase = postAuthCodeUseCase
        self.verifyAuthCodeUseCase = verifyAuthCodeUseCase
        // vender email 정보를 기본값으로 설정
        if let email = infos.venderInfo?.email {
            self.email = email
        }
    }
    
    // emailTextField underline 컬러
    var emailTintColor: Color {
        switch self.emailStatus {
        case .notValid, .exist:
            return Colors.wrongTextField.toColor
        default:
            return focus == .email ? Color.blue : UIColor.placeholderText.toColor
        }
    }
    
    // verificationCodeTextField underline 컬러
    var authCodeTintColor: Color {
        if validVerificationCode == false && authCode.isEmpty {
            return Colors.wrongTextField.toColor
        } else {
            return focus == .verificationCode ? Color.blue : UIColor.placeholderText.toColor
        }
    }
    
    // SignupInfosForPassword 생성 후 반환
    var infosForPassword: SignupInfosForPassword? {
        guard let authToken = self.authToken else { return nil }
        
        return SignupInfosForPassword(
            type: self.infos.type,
            venderInfo: self.infos.venderInfo,
            emailInfo: SignupEmailInfo(
                email: self.email,
                authToken: authToken
            )
        )
    }
    
    // SignupInfosForNickname 생성 후 반환
    var infosForNickname: SignupInfosForNickname? {
        guard let authToken = self.authToken else { return nil }
        
        return SignupInfosForNickname(
            type: self.infos.type,
            venderInfo: self.infos.venderInfo,
            emailInfo: SignupEmailInfo(
                email: self.email,
                authToken: authToken
            ),
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
                    guard case .failure(let networkError) = completion else { return }
                    print("ERROR", #function)
                    self?.handleCheckEmailError(networkError)
                } receiveValue: { [weak self] checkUsernameInfo in
                    if checkUsernameInfo.isNotExist {
                        // 성공, valid 단계
                        self?.emailStatus = .notExist
                        self?.postAuthCode()
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
    
    /// 인증코드 전송, 전송 시점 저장 및 authKey 수신 후 저장
    private func postAuthCode() {
        self.postAuthCodeTerminateDate = Calendar.current.date(byAdding: .minute, value: 5, to: Date())
        self.postAuthCodeUseCase.execute(type: .signup(email: self.email))
            .sink { [weak self] completion in
                guard case .failure(let networkError) = completion else { return }
                print("ERROR", #function)
                self?.handlePostAuthCodeError(networkError)
            } receiveValue: { [weak self] postAuthCodeInfo in
                print("authKey: \(postAuthCodeInfo.authKey)")
                self?.authKey = postAuthCodeInfo.authKey
                self?.resetVerificationCode()
                self?.runTimer()
            }
            .store(in: &self.cancellables)
    }
    
    // 인증코드 유효시간 표시 timer 동작
    func runTimer() {
        DispatchQueue.main.async { [weak self] in
            self?.timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { [weak self] timer in
                guard let postAuthCodeTerminateDate = self?.postAuthCodeTerminateDate else { return }
                let remainSeconds = Int(postAuthCodeTerminateDate.timeIntervalSinceNow)
                if remainSeconds <= 0 {
                    self?.timer?.invalidate()
                    self?.timer = nil
                }
                self?.authCodeRemainSeconds = remainSeconds
            })
        }
    }
    
    // 인증코드 done 액션
    private func verifyAuthCode() {
        guard let authKey = self.authKey else { return }
        let request = VerifyAuthCodeRequest(authKey: authKey, authCode: self.authCode)
        self.verifyAuthCodeUseCase.execute(request: request)
            .sink { [weak self] completion in
                guard case .failure(let networkError) = completion else { return }
                print("ERROR", #function)
                self?.handleVerifyAuthCodeError(networkError)
            } receiveValue: { [weak self] verifyAuthCodeInfo in
                print("authToken: \(verifyAuthCodeInfo.authToken)")
                self?.authToken = verifyAuthCodeInfo.authToken
                self?.validVerificationCode = true
                self?.getVerificationSuccess = true
            }
            .store(in: &self.cancellables)
    }
    
    private func resetEmail() {
        self.validVerificationCode = nil
        self.stage = .email
    }
    
    private func resetVerificationCode() {
        self.authCode = ""
        self.timer?.invalidate()
        self.timer = nil
        self.stage = .verificationCode
    }
}

// MARK: Error Handling

extension SignupEmailModel {
    private func handleCheckEmailError(_ networkError: NetworkError) {
        if case .ERRORRESPONSE(let ttErrorResponse) = networkError {
            print(ttErrorResponse.logMessage)
            self.alert = ttErrorResponse.alertMessage
        } else {
            print(networkError)
            self.alert = TTErrorResponse.defaultAlertMessage
        }
    }
    
    private func handlePostAuthCodeError(_ networkError: NetworkError) {
        if case .ERRORRESPONSE(let ttErrorResponse) = networkError {
            switch ttErrorResponse.code {
            case "AU7000":
                self.alert = TTErrorResponse.defaultAlertMessage
            default:
                self.alert = ttErrorResponse.alertMessage
            }
        } else {
            print(networkError)
            self.alert = TTErrorResponse.defaultAlertMessage
        }
    }
    
    private func handleVerifyAuthCodeError(_ networkError: NetworkError) {
        if case .ERRORRESPONSE(let ttErrorResponse) = networkError {
            switch ttErrorResponse.code {
            case "AU1002":
                self.authCodeStatus = .expired
            case "AU1003":
                self.authCodeStatus = .invalied
            default:
                self.alert = ttErrorResponse.alertMessage
            }
        } else {
            print(networkError)
            self.alert = TTErrorResponse.defaultAlertMessage
        }
    }
}
