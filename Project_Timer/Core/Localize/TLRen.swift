//
//  TLRen.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2023/12/10.
//  Copyright © 2023 FDEE. All rights reserved.
//

import Foundation

struct TLRen {
    static func value(key: TLRkey, op: String? = nil) -> String {
        var value: String = ""
        switch key {
        case .Common_Text_OK: value = "ok"
        case .Common_Text_Next: value = "Next"
        case .Common_Text_Close: value = "Close"
            
        case .Update_Popup_HardUpdateTitle: value = "You have to update the app"
        case .Update_Popup_HardUpdateDesc: value = "Please update the latest version"
        case .Update_Pupup_SoftUpdateTitle: value = "New Version"
        case .Update_Popup_SoftUpdateDesc: value = "Try {} version"
        case .Update_Popup_Update: value = "Update"
        case .Update_Popup_NotNow: value = "Not Now"
            
        case .Settings_Text_ProfileSection: value = "Profile"
        case .Settings_Button_SingInOption: value = "Sign in"
        case .Settings_Button_SingInOptionDesc: value = "Try Synchronization"
        case .Settings_Text_ServiceSection: value = "Service"
        case .Settings_Button_Functions: value = "TiTi Functions"
        case .Settings_Button_TiTiLab: value = "TiTi Lab"
        case .Settings_Text_SettingSection: value = "Setting"
        case .Settings_Button_Notification: value = "Notification"
        case .Settings_Button_UI: value = "UI"
        case .Settings_Button_Control: value = "Control"
        case .Settings_Button_LanguageOption: value = "Language"
        case .Settings_Button_Widget: value = "Widget"
        case .Settings_Text_VersionSection: value = "Version & Update history"
        case .Settings_Button_VersionInfoTitle: value = "Version Info"
        case .Settings_Button_VersionInfoDesc: value = "Latest version"
        case .Settings_Button_UpdateHistory: value = "Update History"
        case .Settings_Text_BackupSection: value = "Backup"
        case .Settings_Button_GetBackup: value = "Get Backup files"
        case .Settings_Text_DeveloperSection: value = "Developer Team"
            
        case .Language_Button_SystemLanguage: value = "System Language"
        case .Language_Button_Korean: value = "Korean"
        case .Language_Button_English: value = "English"
        case .Language_Button_Chinese: value = "Chinese, Simplified"
        case .Language_Popup_LanguageChangeTitle: value = "Language has been changed"
        case .Language_Popup_LanguageChangeDesc: value = "Please restart the app"
            
        case .SignIn_Text_TimerTiTi: value = "TimerTiTi"
        case .SignIn_Button_SocialSignIn: value = "Sign in with {}"
        case .SignIn_Button_WithoutSocialSingIn: value = "Using without Sign in"
        case .SignIn_Hint_Email: value = "Email"
        case .SignIn_Hint_Password: value = "Password"
        case .SignIn_Button_TiTiSingIn: value = "Sign In"
        case .SignIn_Text_OR: value = "OR"
        case .SignIn_Button_FindEmail: value = "Forgot Email?"
        case .SignIn_Button_FindPassword: value = "Forgot Password?"
        case .SignIn_Button_SignUp: value = "Sign Up"
        case .SignIn_Error_SocialSignInFail: value = "Sign in failed"
        case .SignIn_Error_SocialSignInFailDomain: value = "Please check your {} Sign In"
        case .SignIn_Error_EmailSingInFail: value = "Please check you email and password"
            
        case .SignIn_Error_AuthenticationError: value = "Authentication Error"
        case .SignIn_Error_SigninFail: value = "Signin Fail"
        case .SignIn_Popup_SigninSuccess: value = "Signin Success"
        case .SignIn_Error_SigninAgain: value = "Please Sign in again"
        case .SignIn_Error_CheckNicknameOrPassword: value = "Please enter your nickname and password correctly"
            
        case .SignUp_Text_InputEmailTitle: value = "Please enter your Email"
        case .SignUp_Text_InputEmailDesc: value = "We need your email for verification"
        case .SignUp_Hint_Email: value = "Email"
        case .SignUp_Error_WrongEmailFormat: value = "Invalid Format. Please enter in the correct format"
        case .SignUp_Toast_SendCodeComplete: value = "Verification Code has been sent. Please check your email"
        case .SignUp_Hint_VerificationCode: value = "Verification Code"
        case .SignUp_Button_Resend: value = "Resend"
        case .SignUp_Error_DuplicateEmail: value = "This Email is already in use. Please enter another one"
        case .SignUp_Error_WrongCode: value = "Invalid Verification Code. Please check again"
        case .SignUp_Error_TooManySend: value = "Too many attempts. The request is limited for 60 minutes"
        case .SignUp_Error_TooManyConfirm: value = "Too many attempts. The request is limited for 10 minutes"
            
        case .SignUp_Text_InputPasswordTitle: value = "Please create a new password"
        case .SignUp_Text_InputPasswordDesc: value = "Password should be 8 or more characters\ninclude both English and Numbers"
        case .SignUp_Hint_Password: value = "Password"
        case .SignUp_Text_ConfirmPasswordDesc: value = "Please enter it again"
        case .SignUp_Hint_ConfirmPassword: value = "Confirm your password"
        case .SignUp_Error_PasswordFormat: value = "Password should be 8 ~ 20 characters include both English and Numbers.\nSpecial characters are imited to !@#$%^&*() only"
        case .SignUp_Error_PasswordMismatch: value = "The confirm password does not match"
            
        case .SignUp_Text_InputNicknameTitle: value = "Please create your Nickname"
        case .SignUp_Text_InputNicknameDesc: value = "Nickname should be 12 characters or less"
        case .SignUp_Hint_Nickname: value = "Nickname"
        case .SignUp_Error_WrongNicknameFormat: value = "Nickname should be 2 ~ 12 characters.\nSpecial characters are imited to !@#$%^&*() only"
            
        case .SignUp_Error_SignupError: value = "Signup Error"
        case .SignUp_Popup_SignupSuccess: value = "Signup Success"
        case .SignUp_Error_EnterDifferentValue: value = "Please enter your nickname or email in a different value"
        case .SignUp_Error_CheckNicknameOrEmail: value = "Please check your nickname or email (at least 5 characters)"
            
        case .Server_Popup_ServerCantUseTitle: value = "The server is temporarily unavailable"
        case .Server_Popup_ServerCantUseDesc: value = "Please try it later :)"
        case .Server_Error_NetworkError: value = "Network Error"
        case .Server_Error_NetworkTimeout: value = "Network Timeout"
        case .Server_Error_NetworkFetchError: value = "Network Fetch Error"
        case .Server_Error_ServerError: value = "Server Error"
        case .Server_Error_CheckNetwork: value = "Please check the network and try again"
        case .Server_Error_DecodeError: value = "Please update to the latest version of the app"
        case .Server_Error_ServerErrorTryAgain: value = "The server something went wrong. Please try again in a few minutes"
            
        case .Notification_Button_PassToday: value = "Dismiss for Today"
            
        case .Sync_Error_UploadError: value = "Upload Error"
        case .Sync_Error_DownloadError: value = "Download Error"
            
        case .WidgetSetting_Text_DailyTargetTimeDesc: value = "Setting the target time for color density display based on total time by date"
        case .WidgetSetting_Text_Description: value = "About Widget"
        case .WidgetSetting_Button_AddMethod: value = "How to add Widget"
        case .WidgetSetting_Text_WidgetDesc1: value = "Touch and hold an empty area on your Home Screen until the apps jiggle."
        case .WidgetSetting_Text_WidgetDesc2: value = "Tap the ( + ) button in the upper corner."
        case .WidgetSetting_Text_WidgetDesc3: value = "Search for \"TiTi\" and Tap."
        case .WidgetSetting_Text_WidgetDesc4: value = "Select a Widget and size, then Tap \"Add Widget\"."
        case .WidgetSetting_Text_WidgetDesc5: value = "Now you can use Widget!"
        }
        
        if let op = op, value.contains("{}") {
            value = value.replacingOccurrences(of: "{}", with: "\(op)")
        }
        
        return value
    }
}
