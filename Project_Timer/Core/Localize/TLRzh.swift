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
        case .Common_Button_Timer: value = "计时器"
        case .Common_Button_Stopwatch: value = "秒表"
            
        case .Update_Popup_HardUpdateTitle: value = "需要更新"
        case .Update_Popup_HardUpdateDesc: value = "请更新到最新版本"
        case .Update_Pupup_SoftUpdateTitle: value = "新版本发布"
        case .Update_Popup_SoftUpdateDesc: value = "{} 请使用版本"
        case .Update_Popup_Update: value = "更新"
        case .Update_Popup_NotNow: value = "不是现在"
            
        case .Settings_Text_ProfileSection: value = "個人資料"
        case .Settings_Button_SingInOption: value = "登录"
        case .Settings_Button_SingInOptionDesc: value = "尝试同步"
        case .Settings_Text_ServiceSection: value = "服务"
        case .Settings_Button_Functions: value = "功能"
        case .Settings_Button_TiTiLab: value = "TiTi实验室"
        case .Settings_Text_SettingSection: value = "设置"
        case .Settings_Button_Notification: value = "通知"
        case .Settings_Button_UI: value = "用户界面"
        case .Settings_Button_Control: value = "控制"
        case .Settings_Button_LanguageOption: value = "语言"
        case .Settings_Button_Widget: value = "小部件"
        case .Settings_Text_VersionSection: value = "版本和更新历史"
        case .Settings_Button_VersionInfoTitle: value = "版本信息"
        case .Settings_Button_VersionInfoDesc: value = "最新版本"
        case .Settings_Button_UpdateHistory: value = "更新细目"
        case .Settings_Text_BackupSection: value = "备份"
        case .Settings_Button_GetBackup: value = "获取备份文件"
        case .Settings_Text_DeveloperSection: value = "开发团队"
            
        case .SwitchSetting_Button_Update: value = "更新"
        case .SwitchSetting_Button_5minNotiDesc: value = "结束前5分钟提醒"
        case .SwitchSetting_Button_EndNotiDesc: value = "结束"
        case .SwitchSetting_Button_1HourPassNotiDesc: value = "每隔1小时提醒"
        case .SwitchSetting_Button_NewVerNotiDesc: value = "新版本弹出警报"
        case .SwitchSetting_Button_TimeAnimationTitle: value = "时间变化动画"
        case .SwitchSetting_Button_TimeAnimationDesc: value = "平滑显示时间变化"
        case .SwitchSetting_Button_BigUITitle: value = "大型用户界面"
        case .SwitchSetting_Button_BigUIDesc: value = "为 iPad 使用 Big UI"
        case .SwitchSetting_Button_KeepScreenOnTitle: value = "始终保持屏幕打开"
        case .SwitchSetting_Button_KeepScreenOnDesc: value = "在录制过程中保持屏幕打开"
        case .SwitchSetting_Button_FlipStartTitle: value = "翻转开始录制"
        case .SwitchSetting_Button_FlipStartDesc: value = "翻转机器后自动开始记录"
            
        case .TiTiLab_Text_DevelopNews: value = "开发新闻"
        case .TiTiLab_Button_InstagramDesc: value = "通过Instagram查看各种开发消息"
        case .TiTiLab_Text_PartInDev: value = "参与TiTi开发"
        case .TiTiLab_Text_SurveyTitle: value = "调查问卷"
        case .TiTiLab_Text_SurveyDesc: value = "实时显示新的调查。\n参与新功能的开发和改进。"
        case .TiTiLab_Text_NoServey: value = "目前没有正在进行的问卷调查。"
        case .TiTiLab_Text_Sync: value = "同步"
        case .TiTiLab_Button_SignUpTitle: value = "注册会员"
        case .TiTiLab_Button_SignUpDesc: value = "Dailys 记录同步 (beta)"
        case .TiTiLab_Button_SignIn: value = "登录"
            
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
            
        case .SignIn_Error_AuthenticationError: value = "验证错误"
        case .SignIn_Error_SigninFail: value = "登录失败"
        case .SignIn_Popup_SigninSuccess: value = "登录成功"
        case .SignIn_Error_SigninAgain: value = "请重新登录"
        case .SignIn_Error_CheckNicknameOrPassword: value = "请正确输入您的昵称和密码"
            
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
            
        case .SignUp_Error_SignupError: value = "注册错误"
        case .SignUp_Popup_SignupSuccess: value = "注册成功"
        case .SignUp_Error_EnterDifferentValue: value = "请输入您的昵称或电子邮件为不同的值"
        case .SignUp_Error_CheckNicknameOrEmail: value = "请检查您的昵称或电子邮件（至少5个字符）"
            
        case .Server_Popup_ServerCantUseTitle: value = "暂时无法使用服务器"
        case .Server_Popup_ServerCantUseDesc: value = "请稍后使用 :)"
        case .Server_Error_NetworkError: value = "网络错误"
        case .Server_Error_NetworkTimeout: value = "网络超时"
        case .Server_Error_NetworkFetchError: value = "网络获取错误"
        case .Server_Error_ServerError: value = "服务器错误"
        case .Server_Error_CheckNetwork: value = "请检查网络并重试"
        case .Server_Error_DecodeError: value = "请更新到最新版本的应用程序"
        case .Server_Error_ServerErrorTryAgain: value = "服务器出错啦! 请稍后再试。"
            
        case .Notification_Button_PassToday: value = "今日不再显示"
            
        case .Sync_Error_UploadError: value = "上传错误"
        case .Sync_Error_DownloadError: value = "下载错误"
            
        case .WidgetSetting_Text_DailyTargetTimeDesc: value = "根据日期的总时间设置颜色密度显示的目标时间"
        case .WidgetSetting_Text_Description: value = "关于小部件"
        case .WidgetSetting_Button_AddMethod: value = "如何添加小部件"
        case .WidgetSetting_Text_WidgetDesc1: value = "触摸并按住主屏幕上的空区域,直到应用程序抖动。"
        case .WidgetSetting_Text_WidgetDesc2: value = "点击上角的 ( + ) 按钮。"
        case .WidgetSetting_Text_WidgetDesc3: value = "搜索\"TiTi\"后点击。"
        case .WidgetSetting_Text_WidgetDesc4: value = "选择一个小部件和大小，然后轻按\"添加小部件\"。"
        case .WidgetSetting_Text_WidgetDesc5: value = "现在你可以使用小部件了！"
        }
        
        if let op = op, value.contains("{}") {
            value = value.replacingOccurrences(of: "{}", with: "\(op)")
        }
        
        return value
    }
}
