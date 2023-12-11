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
        case .Update_Popup_HardUpdateTitle: value = "需要更新"
        case .Update_Popup_HardUpdateDesc: value = "请更新到最新版本"
        case .Update_Pupup_SoftUpdateTitle: value = "新版本发布"
        case .Update_Popup_SoftUpdateDesc: value = "{} 请使用版本"
        case .Update_Popup_Update: value = "更新"
        case .Update_Popup_NotNow: value = "不是现在"
        case .ok: value = "确认"
            
        case .Settings_Button_SingInOption: value = "登录"
        case .Settings_Button_SingInOptionDesc: value = "尝试同步"
            
        case .SignIn_Text_TimerTiTi: value = "TimerTiTi"
        case .SignIn_Button_SocialSignIn: value = "使用 {} 登录"
        case .SignIn_Button_WithoutSocialSingIn: value = "无需登录即可使用"
        case .SignIn_Hint_Email: value = "电子邮件"
        case .SignIn_Hint_Password: value = "密码 "
        case .SignIn_Button_TiTiSingIn: value = "登录"
        case .SignIn_Text_OR: value = "或者"
        case .SignIn_Button_FindEmail: value = "忘记电子邮件？"
        case .SignIn_Button_FindPassword: value = "忘记密码?"
        case .SignUp_Button_SignUp: value = "注册会员"
            
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
        }
        
        if let op = op, value.contains("{}") {
            value = value.replacingOccurrences(of: "{}", with: "\(op)")
        }
        
        return value
    }
}
