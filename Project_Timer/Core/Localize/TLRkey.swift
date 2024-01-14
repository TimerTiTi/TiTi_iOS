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
    /// 타이머
    case Common_Button_Timer
    /// 스톱워치
    case Common_Button_Stopwatch
    
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
    
    /// 프로필
    case Settings_Text_ProfileSection
    /// 로그인하기
    case Settings_Button_SingInOption
    /// 동기화 기능을 사용해보세요
    case Settings_Button_SingInOptionDesc
    /// 서비스
    case Settings_Text_ServiceSection
    /// TiTi 기능들
    case Settings_Button_Functions
    /// TiTi 연구소
    case Settings_Button_TiTiLab
    /// 설정
    case Settings_Text_SettingSection
    /// 알림
    case Settings_Button_Notification
    /// UI
    case Settings_Button_UI
    /// 제어
    case Settings_Button_Control
    /// 언어
    case Settings_Button_LanguageOption
    /// 위젯
    case Settings_Button_Widget
    /// 버전 및 업데이트 내역
    case Settings_Text_VersionSection
    /// 버전 정보
    case Settings_Button_VersionInfoTitle
    /// 최신 버전
    case Settings_Button_VersionInfoDesc
    /// 업데이트 내역
    case Settings_Button_UpdateHistory
    /// 백업
    case Settings_Text_BackupSection
    /// 백업 파일 추출
    case Settings_Button_GetBackup
    /// 개발팀
    case Settings_Text_DeveloperSection
    
    /// 업데이트
    case SwitchSetting_Button_Update
    /// 종료 5분전 알림
    case SwitchSetting_Button_5minNotiDesc
    /// 종료 알림
    case SwitchSetting_Button_EndNotiDesc
    /// 1시간단위 경과시 알림
    case SwitchSetting_Button_1HourPassNotiDesc
    /// 최신버전 업데이트 알림
    case SwitchSetting_Button_NewVerNotiDesc
    /// 시간 변화 애니메이션
    case SwitchSetting_Button_TimeAnimationTitle
    /// 시간 변화를 부드럽게 표시해요
    case SwitchSetting_Button_TimeAnimationDesc
    
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
    
    /// 인증정보 오류
    case SignIn_Error_AuthenticationError
    /// 로그인 실패
    case SignIn_Error_SigninFail
    /// 로그인 성공
    case SignIn_Popup_SigninSuccess
    /// 다시 로그인해주세요
    case SignIn_Error_SigninAgain
    /// 닉네임과 패스워드를 정확히 입력해주세요
    case SignIn_Error_CheckNicknameOrPassword
    
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
    
    /// 회원가입 불가
    case SignUp_Error_SignupError
    /// 회원가입 성공
    case SignUp_Popup_SignupSuccess
    /// 닉네임, 또는 이메일을 다른값으로 입력해주세요
    case SignUp_Error_EnterDifferentValue
    /// 닉네임 또는 이메일을 확인해주세요 (5자리 이상)
    case SignUp_Error_CheckNicknameOrEmail
    
    /// 서버를 일시적으로 사용할 수 없어요
    case Server_Popup_ServerCantUseTitle
    /// 잠시 후 이용해 주세요
    case Server_Popup_ServerCantUseDesc
    /// 네트워크 오류
    case Server_Error_NetworkError
    /// 네트워크 시간초과
    case Server_Error_NetworkTimeout
    /// 네트워크 수신불가
    case Server_Error_NetworkFetchError
    /// 서버 오류
    case Server_Error_ServerError
    /// 네트워크를 확인 후 다시 시도해주세요
    case Server_Error_CheckNetwork
    /// 최신 버전의 앱으로 업데이트를 해주세요
    case Server_Error_DecodeError
    /// 서버에 오류가 발생했습니다. 잠시 후 다시 시도해주세요
    case Server_Error_ServerErrorTryAgain
    
    /// 오늘 그만보기
    case Notification_Button_PassToday
    
    /// 업로드 오류
    case Sync_Error_UploadError
    /// 다운로드 오류
    case Sync_Error_DownloadError
    
    /// 날짜별 누적 시간에 따른 색 농도표시를 위한 목표 시간을 설정합니다
    case WidgetSetting_Text_DailyTargetTimeDesc
    /// 위젯 설명
    case WidgetSetting_Text_Description
    /// 위젯 추가 방법
    case WidgetSetting_Button_AddMethod
    /// 앱들이 흔들릴 때까지 홈 스크린의 빈 영역을 길게 눌러요
    case WidgetSetting_Text_WidgetDesc1
    /// 상단 모서리에 있는 ( + ) 버튼을 터치해요
    case WidgetSetting_Text_WidgetDesc2
    /// \"TiTi\"를 검색한 후 터치해요
    case WidgetSetting_Text_WidgetDesc3
    /// 위젯과 사이즈를 선택하고 \"위젯 추가\"를 터치해요
    case WidgetSetting_Text_WidgetDesc4
    /// 그러면 위젯을 사용할 수 있어요!
    case WidgetSetting_Text_WidgetDesc5
}
