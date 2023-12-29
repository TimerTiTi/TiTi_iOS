//
//  TLRzh.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2023/12/10.
//  Copyright © 2023 FDEE. All rights reserved.
//

import Foundation

struct TLRzh {
    static func value(key: TLRkey, op: String? = nil) -> String {
        var value: String = ""
        switch key {
        case .Common_Text_OK: value = "确认"
        case .Common_Text_Next: value = "下一页"
        case .Common_Text_Close: value = "关闭"
            
        case .Update_Popup_HardUpdateTitle: value = "需要更新"
        case .Update_Popup_HardUpdateDesc: value = "请更新到最新版本"
        case .Update_Pupup_SoftUpdateTitle: value = "新版本发布"
        case .Update_Popup_SoftUpdateDesc: value = "{} 请使用版本"
        case .Update_Popup_Update: value = "更新"
        case .Update_Popup_NotNow: value = "不是现在"
            
        case .Settings_Button_SingInOption: value = "登录"
        case .Settings_Button_SingInOptionDesc: value = "尝试同步"
        case .Settings_Button_LanguageOption: value = "语言"
        case .Language_Button_SystemLanguage: value = "System 语言"
        case .Language_Button_Korean: value = "韩语"
        case .Language_Button_English: value = "英语"
        case .Language_Button_Chinese: value = "简体中文"
        case .Language_Popup_LanguageChangeTitle: value = "语言已更改"
        case .Language_Popup_LanguageChangeDesc: value = "请重启APP"
            
        case .SignIn_Text_TimerTiTi: value = "TimerTiTi"
        case .SignIn_Button_SocialSignIn: value = "使用 {} 登录"
        case .SignIn_Button_WithoutSocialSingIn: value = "无需登录即可使用"
        case .SignIn_Hint_Email: value = "电子邮件"
        case .SignIn_Hint_Password: value = "密码 "
        case .SignIn_Button_TiTiSingIn: value = "登录"
        case .SignIn_Text_OR: value = "或者"
        case .SignIn_Button_FindEmail: value = "忘记电子邮件？"
        case .SignIn_Button_FindPassword: value = "忘记密码?"
        case .SignIn_Button_SignUp: value = "注册会员"
        case .SignIn_Error_SocialSignInFail: value = "登录失败"
        case .SignIn_Error_SocialSignInFailDomain: value = "请检查您的 {} 登录"
        case .SignIn_Error_EmailSingInFail: value = "请检查您的电子邮件和密码"
            
        case .SignUp_Text_InputEmailTitle: value = "请输入您的电子邮件地址"
        case .SignUp_Text_InputEmailDesc: value = "我们需要您的电子邮件进行验证"
        case .SignUp_Hint_Email: value = "电子邮件"
        case .SignUp_Error_WrongEmailFormat: value = "无效的格式。 请输入正确的格式"
        case .SignUp_Toast_SendCodeComplete: value = "验证码已发送。 请检查您的电子邮件"
        case .SignUp_Hint_VerificationCode: value = "验证码"
        case .SignUp_Button_Resend: value = "重新发送"
        case .SignUp_Error_DuplicateEmail: value = "此电子邮件已在使用中。 请输入另一个"
        case .SignUp_Error_WrongCode: value = "验证码错误。 请再次检查"
        case .SignUp_Error_TooManySend: value = "太多的尝试。 请求被限制为60分钟"
        case .SignUp_Error_TooManyConfirm: value = "太多的尝试。 请求限制为10分钟"
            
        case .SignUp_Text_InputPasswordTitle: value = "请创建新密码"
        case .SignUp_Text_InputPasswordDesc: value = "密码必须是8个或更多字符（包括英文和数字）"
        case .SignUp_Hint_Password: value = "密码"
        case .SignUp_Text_ConfirmPasswordDesc: value = "请再次输入"
        case .SignUp_Hint_ConfirmPassword: value = "确认您的密码"
        case .SignUp_Error_PasswordFormat: value = "密码应为8~20个字符，包括英语和数字。\n特殊字符被模仿 !@#$%^&*() 仅限"
        case .SignUp_Error_PasswordMismatch: value = "不一样。 请重新输入"
            
        case .SignUp_Text_InputNicknameTitle: value = "请创建您的昵称"
        case .SignUp_Text_InputNicknameDesc: value = "昵称应为12个字符或更少"
        case .SignUp_Hint_Nickname: value = "昵称"
        case .SignUp_Error_WrongNicknameFormat: value = "昵称应该是2~12个字符。\n特殊字符被模仿 !@#$%^&*() 仅限"
            
        case .Server_Popup_ServerCantUseTitle: value = "暂时无法使用服务器"
        case .Server_Popup_ServerCantUseDesc: value = "请稍后使用 :)"
            
        case .Notification_Button_PassToday: value = "今日不再显示"
        }
        
        if let op = op, value.contains("{}") {
            value = value.replacingOccurrences(of: "{}", with: "\(op)")
        }
        
        return value
    }
}
