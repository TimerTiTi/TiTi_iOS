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
    
    // MARK: State
    
    @Published var contentWidth: CGFloat = .zero
    @Published var focus: TTSignupTextFieldView.type?
    @Published var isWarningEmail: Bool = false
    @Published var validVerificationCode: Bool?
    @Published var getVerificationSuccess: Bool = false
    @Published var stage: Stage = .email
    
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
        case networkError
        case notExist
        
        var errorMessage: String {
            switch self {
            case .notValid: return Localized.string(.SignUp_Error_WrongEmailFormat)
            case .exist: return "동일한 이메일이 존재합니다. 다른 이메일을 입력해주세요"
            case .networkError: return "네트워크 오류가 발생했습니다."
            case .notExist: return ""
            }
        }
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
    private var postAuthCodeTerminateDate: Date? // authCode 만료 시점
    private var authKey: String? // authCode 전송시 서버로부터 받은 5분간 유효한 authKey
    private var authToken: String? // authCode 검증 성공시 서버로부터 받은 30분간 유효한 authToken
    private var timer: Timer? // authCode 전송 후 남은 시간, 1초간 업데이트
    
    private let getUsernameNotExistUseCase: GetUsernameNotExistUseCase
    private let postAuthCodeUseCase: PostAuthCodeUseCase
    private let verifyAuthCodeUseCase: VerifyAuthCodeUseCase
    private var cancellables = Set<AnyCancellable>()
    
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
        case .notValid, .exist, .networkError:
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
                // TODO: 인증코드 전송 실패시 핸들링
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
                // TODO: 인증코드 검증 실패시 핸들링
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

extension SignupEmailModel {
    private func handleCheckEmailError(_ networkError: NetworkError) {
        // TODO: 서버 문제, 요청 문제 등 분기처리 필요
        self.emailStatus = .networkError
        guard case .ERRORRESPONSE(let ttErrorResponse) = networkError else { return }
        print(ttErrorResponse.logMessage)
        // TODO: 오류문구 표시가 필요한 경우 반영
        print("title: \(ttErrorResponse.errorTitle)")
        print("message: \(ttErrorResponse.errorMessage)")
    }
}
