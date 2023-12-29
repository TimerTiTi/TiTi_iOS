//
//  TLRkey.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2023/12/11.
//  Copyright © 2023 FDEE. All rights reserved.
//

import Foundation

enum TLRkey: String {
    /// 확인
    case Common_Text_OK
    /// 다음
    case Common_Text_Next
    /// 닫기
    case Common_Text_Close
    
    /// 업데이트가 필요해요
    case Update_Popup_HardUpdateTitle
    /// 최신버전으로 업데이트 해주세요
    case Update_Popup_HardUpdateDesc
    /// 새로운 업데이트 알림
    case Update_Pupup_SoftUpdateTitle
    /// {} 버전을 사용해보세요 :)
    case Update_Popup_SoftUpdateDesc
    /// 업데이트
    case Update_Popup_Update
    /// 나중에
    case Update_Popup_NotNow
    
    /// 로그인하기
    case Settings_Button_SingInOption
    /// 동기화 기능을 사용해보세요
    case Settings_Button_SingInOptionDesc
    /// 언어
    case Settings_Button_LanguageOption
    
    /// System 언어
    case Language_Button_SystemLanguage
    /// 한국어
    case Language_Button_Korean
    /// 영어
    case Language_Button_English
    /// 중국어(간체)
    case Language_Button_Chinese
    /// 언어가 변경되었어요
    case Language_Popup_LanguageChangeTitle
    ///앱을 다시 실행해주세요
    case Language_Popup_LanguageChangeDesc
    
    /// 타이머티티
    case SignIn_Text_TimerTiTi
    /// {}로 로그인
    case SignIn_Button_SocialSignIn
    /// 로그인없이 서비스 이용하기
    case SignIn_Button_WithoutSocialSingIn
    /// 이메일
    case SignIn_Hint_Email
    /// 비밀번호
    case SignIn_Hint_Password
    /// 로그인
    case SignIn_Button_TiTiSingIn
    /// 또는
    case SignIn_Text_OR
    /// 이메일 찾기
    case SignIn_Button_FindEmail
    /// 비밀번호 찾기
    case SignIn_Button_FindPassword
    /// 회원가입
    case SignIn_Button_SignUp
    /// 로그인을 실패했어요
    case SignIn_Error_SocialSignInFail
    /// {} 로그인을 확인해주세요
    case SignIn_Error_SocialSignInFailDomain
    /// 이메일과 비밀번호를 확인해주세요
    case SignIn_Error_EmailSingInFail
    
    /// 이메일을 입력해 주세요
    case SignUp_Text_InputEmailTitle
    /// 이메일 인증으로 본인을 확인해 주세요
    case SignUp_Text_InputEmailDesc
    /// 이메일
    case SignUp_Hint_Email
    /// 잘못된 형식입니다. 올바른 형식으로 입력해 주세요
    case SignUp_Error_WrongEmailFormat
    /// 인증코드가 발송되었습니다. 이메일을 확인해 주세요
    case SignUp_Toast_SendCodeComplete
    /// 인증코드
    case SignUp_Hint_VerificationCode
    /// 재전송
    case SignUp_Button_Resend
    /// 이미 사용 중인 이메일입니다. 다른 이메일을 입력해 주세요
    case SignUp_Error_DuplicateEmail
    /// 인증코드가 올바르지 않습니다. 다시 확인해 주세요
    case SignUp_Error_WrongCode
    /// 인증코드 전송 시도가 너무 많습니다. 60분간 요청이 제한돼요
    case SignUp_Error_TooManySend
    /// 인증코드 확인 시도가 너무 많습니다. 10분간 요청이 제한돼요
    case SignUp_Error_TooManyConfirm
    
    /// 비밀번호를 입력해 주세요
    case SignUp_Text_InputPasswordTitle
    /// 8자리 이상 비밀번호를 입력해 주세요 (영어, 숫자 포함)
    case SignUp_Text_InputPasswordDesc
    /// 비밀번호
    case SignUp_Hint_Password
    /// 다시 한번 입력해 주세요
    case SignUp_Text_ConfirmPasswordDesc
    /// 비밀번호 재입력
    case SignUp_Hint_ConfirmPassword
    /// "영문, 숫자를 포함하여 8자 이상 20자 이내로 입력해 주세요. 특수문자는 !@#$%^&*()만 가능합니다"
    case SignUp_Error_PasswordFormat
    /// 동일하지 않습니다. 다시 입력해 주세요
    case SignUp_Error_PasswordMismatch
    
    /// 닉네임을 입력해 주세요
    case SignUp_Text_InputNicknameTitle
    /// 12자 이내로 닉네임을 입력해 주세요
    case SignUp_Text_InputNicknameDesc
    /// 닉네임
    case SignUp_Hint_Nickname
    /// "2자 이상 12자 이내로 입력해 주세요. 특수문자는 !@#$%^&*()만 가능합니다"
    case SignUp_Error_WrongNicknameFormat
    
    /// 서버를 일시적으로 사용할 수 없어요
    case Server_Popup_ServerCantUseTitle
    /// 잠시 후 이용해 주세요
    case Server_Popup_ServerCantUseDesc
    
    /// 오늘 그만보기
    case Notification_Button_PassToday
}
