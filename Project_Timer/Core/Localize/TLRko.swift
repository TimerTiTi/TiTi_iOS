//
//  TLRko.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2023/12/10.
//  Copyright © 2023 FDEE. All rights reserved.
//

import Foundation

struct TLRko {
    static func value(key: TLRkey, op: String? = nil) -> String {
        var value: String = ""
        switch key {
        case .Update_Popup_HardUpdateTitle: value = "업데이트가 필요해요"
        case .Update_Popup_HardUpdateDesc: value = "최신버전으로 업데이트 해주세요"
        case .Update_Pupup_SoftUpdateTitle: value = "새로운 업데이트 알림"
        case .Update_Popup_SoftUpdateDesc: value = "{} 버전을 사용해보세요 :)"
        case .Update_Popup_Update: value = "업데이트"
        case .Update_Popup_NotNow: value = "나중에"
        case .ok: value = "확인"
            
        case .Settings_Button_SingInOption: value = "로그인하기"
        case .Settings_Button_SingInOptionDesc: value = "동기화 기능을 사용해보세요"
        case .Settings_Button_LanguageOption: value = "언어"
            
        case .Language_Button_SystemLanguage: value = "System 언어"
        case .Language_Button_Korean: value = "한국어"
        case .Language_Button_English: value = "영어"
        case .Language_Button_Chinese: value = "중국어(간체)"
        case .Language_Popup_LanguageChangeTitle: value = "언어가 변경되었어요"
        case .Language_Popup_LanguageChangeDesc: value = "앱을 다시 실행해주세요"
            
        case .SignIn_Text_TimerTiTi: value = "타이머티티"
        case .SignIn_Button_SocialSignIn: value = "{}로 로그인"
        case .SignIn_Button_WithoutSocialSingIn: value = "로그인없이 서비스 이용하기"
        case .SignIn_Hint_Email: value = "이메일"
        case .SignIn_Hint_Password: value = "비밀번호"
        case .SignIn_Button_TiTiSingIn: value = "로그인"
        case .SignIn_Text_OR: value = "또는"
        case .SignIn_Button_FindEmail: value = "이메일 찾기"
        case .SignIn_Button_FindPassword: value = "비밀번호 찾기"
        case .SignIn_Button_SignUp: value = "회원가입"
        case .SignIn_Error_SocialSignInFail: value = "로그인을 실패했어요"
        case .SignIn_Error_SocialSignInFailDomain: value = "{} 로그인을 확인해주세요"
        case .SignIn_Error_EmailSingInFail: value = "이메일과 비밀번호를 확인해주세요"
            
        case .SignUp_Text_InputEmailTitle: value = "이메일을 입력해 주세요"
        case .SignUp_Text_InputEmailDesc: value = "이메일 인증으로 본인을 확인해 주세요"
        case .SignUp_Hint_Email: value = "이메일"
        case .SignUp_Error_WrongEmailFormat: value = "잘못된 형식입니다. 올바른 형식으로 입력해 주세요"
        case .SignUp_Toast_SendCodeComplete: value = "인증코드가 발송되었습니다. 이메일을 확인해 주세요"
        case .SignUp_Hint_VerificationCode: value = "인증코드"
        case .SignUp_Button_Resend: value = "재전송"
        case .SignUp_Error_DuplicateEmail: value = "이미 사용 중인 이메일입니다. 다른 이메일을 입력해 주세요"
        case .SignUp_Error_WrongCode: value = "인증코드가 올바르지 않습니다. 다시 확인해 주세요"
        case .SignUp_Error_TooManySend: value = "인증코드 전송 시도가 너무 많습니다. 60분간 요청이 제한돼요"
        case .SignUp_Error_TooManyConfirm: value = "인증코드 확인 시도가 너무 많습니다. 10분간 요청이 제한돼요"
            
        case .SignUp_Text_InputPasswordTitle: value = "비밀번호를 입력해 주세요"
        case .SignUp_Text_InputPasswordDesc: value = "8자리 이상 비밀번호를 입력해 주세요 (영어, 숫자 포함)"
        case .SignUp_Hint_Password: value = "비밀번호"
        case .SignUp_Text_ConfirmPasswordDesc: value = "다시 한번 입력해 주세요"
        case .SignUp_Hint_ConfirmPassword: value = "비밀번호 재입력"
        case .SignUp_Error_PasswordFormat: value = "영문, 숫자를 포함하여 8자 이상 20자 이내로 입력해 주세요.\n특수문자는 !@#$%^&*()만 가능합니다"
        case .SignUp_Error_PasswordMismatch: value = "동일하지 않습니다. 다시 입력해 주세요"
            
        case .SignUp_Text_InputNicknameTitle: value = "닉네임을 입력해 주세요"
        case .SignUp_Text_InputNicknameDesc: value = "12자 이내로 닉네임을 입력해 주세요"
        case .SignUp_Hint_Nickname: value = "닉네임"
        case .SignUp_Error_WrongNicknameFormat: value = "2자 이상 12자 이내로 입력해 주세요.\n특수문자는 !@#$%^&*()만 가능합니다"
        }
        
        if let op = op, value.contains("{}") {
            value = value.replacingOccurrences(of: "{}", with: "\(op)")
        }
        
        return value
    }
}
