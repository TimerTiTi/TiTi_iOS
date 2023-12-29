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
        case .Common_Text_OK: value = "확인"
        case .Common_Text_Next: value = "다음"
        case .Common_Text_Close: value = "닫기"
            
        case .Update_Popup_HardUpdateTitle: value = "업데이트가 필요해요"
        case .Update_Popup_HardUpdateDesc: value = "최신버전으로 업데이트 해주세요"
        case .Update_Pupup_SoftUpdateTitle: value = "새로운 업데이트 알림"
        case .Update_Popup_SoftUpdateDesc: value = "{} 버전을 사용해보세요 :)"
        case .Update_Popup_Update: value = "업데이트"
        case .Update_Popup_NotNow: value = "나중에"
            
        case .Settings_Button_SingInOption: value = "로그인하기"
        case .Settings_Button_SingInOptionDesc: value = "동기화 기능을 사용해보세요"
        case .Settings_Button_LanguageOption: value = "언어"
        case .Settings_Button_Widget: value = "위젯"
            
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
            
        case .SignIn_Error_AuthenticationError: value = "인증정보 오류"
        case .SignIn_Error_SigninFail: value = "로그인 실패"
        case .SignIn_Popup_SigninSuccess: value = "로그인 성공"
        case .SignIn_Error_SigninAgain: value = "다시 로그인해주세요"
        case .SignIn_Error_CheckNicknameOrPassword: value = "닉네임과 패스워드를 정확히 입력해주세요"
            
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
            
        case .SignUp_Error_SignupError: value = "회원가입 불가"
        case .SignUp_Popup_SignupSuccess: value = "회원가입 성공"
        case .SignUp_Error_EnterDifferentValue: value = "닉네임, 또는 이메일을 다른값으로 입력해주세요"
        case .SignUp_Error_CheckNicknameOrEmail: value = "닉네임 또는 이메일을 확인해주세요 (5자리 이상)"
            
        case .Server_Popup_ServerCantUseTitle: value = "서버를 일시적으로 사용할 수 없어요"
        case .Server_Popup_ServerCantUseDesc: value = "잠시 후 이용해 주세요 :)"
        case .Server_Error_NetworkError: value = "네트워크 오류"
        case .Server_Error_NetworkTimeout: value = "네트워크 시간초과"
        case .Server_Error_NetworkFetchError: value = "네트워크 수신불가"
        case .Server_Error_ServerError: value = "서버 오류"
        case .Server_Error_CheckNetwork: value = "네트워크를 확인 후 다시 시도해주세요"
        case .Server_Error_DecodeError: value = "최신 버전의 앱으로 업데이트를 해주세요"
        case .Server_Error_ServerErrorTryAgain: value = "서버에 오류가 발생했습니다. 잠시 후 다시 시도해주세요"
            
        case .Notification_Button_PassToday: value = "오늘 그만보기"
            
        case .Sync_Error_UploadError: value = "업로드 오류"
        case .Sync_Error_DownloadError: value = "다운로드 오류"
            
        case .WidgetSetting_Text_DailyTargetTimeDesc: value = "날짜별 누적 시간에 따른 색 농도표시를 위한 목표 시간을 설정합니다"
        case .WidgetSetting_Text_Description: value = "위젯 설명"
        case .WidgetSetting_Button_AddMethod: value = "위젯 추가 방법"
        case .WidgetSetting_Text_WidgetDesc1: value = "앱들이 흔들릴 때까지 홈 스크린의 빈 영역을 길게 눌러요"
        case .WidgetSetting_Text_WidgetDesc2: value = "상단 모서리에 있는 ( + ) 버튼을 터치해요"
        case .WidgetSetting_Text_WidgetDesc3: value = "\"TiTi\"를 검색한 후 터치해요"
        case .WidgetSetting_Text_WidgetDesc4: value = "위젯과 사이즈를 선택하고 \"위젯 추가\"를 터치해요"
        case .WidgetSetting_Text_WidgetDesc5: value = "그러면 위젯을 사용할 수 있어요!"
        }
        
        if let op = op, value.contains("{}") {
            value = value.replacingOccurrences(of: "{}", with: "\(op)")
        }
        
        return value
    }
}
