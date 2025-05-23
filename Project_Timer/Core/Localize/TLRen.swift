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
        case .Common_Text_OK: value = "Ok"
        case .Common_Text_Cencel: value = "Cancel"
        case .Common_Text_Edit: value = "Edit"
        case .Common_Text_Done: value = "Done"
        case .Common_Text_Next: value = "Next"
        case .Common_Text_Close: value = "Close"
        case .Common_Text_Delete: value = "Delete"
        case .Common_Text_Back: value = "Back"
        case .Common_Text_Add: value = "Add"
        case .Common_Text_Timer: value = "Timer"
        case .Common_Text_Stopwatch: value = "Stopwatch"
        case .Common_Text_TargetTime: value = "Target time"
        case .Common_Popup_SetMonthTargetTime: value = "Input Month's Target time (Hour)"
        case .Common_Popup_SetWeekTargetTime: value = "Input Week's Target time (Hour)"
        case .Common_Popup_SetDailyTargetTime: value = "Input Daily's Target time (Hour)"
        case .Common_Popup_SaveCompleted: value = "Save Completed"
        case .Common_Popup_Warning: value = "Warning"
        case .Common_Popup_Inform: value = "Inform"
            
        case .App_Popup_FetchVersionErrorTitle: value = "Failed to fetch the latest version information"
        case .App_Popup_FetchVersionErrorDesc: value = "If the issue persists, please contact support."
            
        case .System_Noti_StopwatchHourPassed: value = "{}hours passed."
        case .System_Noti_TimerFinished: value = "Timer finished!"
        case .System_Noti_Timer5Left: value = "5 minutes left"
        case .System_Noti_RecordingStart: value = "Recording started"
            
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
        case .Settings_Button_Record: value = "Record"
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
            
        case .TiTiLab_Text_DevelopNews: value = "Develop News"
        case .TiTiLab_Button_InstagramDesc: value = "Check out various Development news on Instagram"
        case .TiTiLab_Text_PartInDev: value = "Participation in Develop"
        case .TiTiLab_Text_SurveyTitle: value = "Survey"
        case .TiTiLab_Text_SurveyDesc: value = "New surveys will be displayed in real time.\nParticipate in the development and improvement of new features"
        case .TiTiLab_Text_NoServey: value = "No surveys in progress."
        case .TiTiLab_Text_Sync: value = "Synchronization"
        case .TiTiLab_Button_SignUpTitle: value = "Sign Up"
        case .TiTiLab_Button_SignUpDesc: value = "for Synclonize Dailys (beta)"
        case .TiTiLab_Button_SignIn: value = "Sign In"
        case .TiTiLab_Button_SignOut: value = "Sign Out"
        case .TiTiLab_Popup_SignOutTitle: value = "Do you want to Signout?"
            
        case .SyncDaily_Text_InfoSync1: value = "The last synchronization time of the current device and the latest synchronization time reflected in the server."
        case .SyncDaily_Text_InfoSync2: value = "Synchronization backs up your modified data and allows you to receive data backed up from other devices."
        case .SyncDaily_Text_InfoSync3: value = "The number of Dailys stored on the server and the number of Dailys on the current device."
        case .SyncDaily_Text_InfoSync4: value = "Created and Edited dailys are backed up at the time of synchronized."
        case .SyncDaily_Button_SyncNow: value = "Sync Now"
        case .SyncDaily_Popup_InfoFirstSyncTitle: value = "First Sync"
        case .SyncDaily_Popup_InfoFirstSyncDesc: value = "For the first synchronization, it may take a long time for all Daily information to be reflected (10s), so please wait without shutting down the app."
            
        case .SettingRecord_Text_RecordResetTimeTitle: value = "Reset Time for New Record Date"
        case .SettingRecord_Text_RecordResetTimeDesc: value = "A new day's record starts based on the reset time."
        case .SettingRecord_Popup_InputRecordResetTime: value = "Please enter the reset time to set in 24-hour format (0–23)."
            
        case .SwitchSetting_Button_Update: value = "Update"
        case .SwitchSetting_Button_5minNotiDesc: value = "5 minutes before end"
        case .SwitchSetting_Button_EndNotiDesc: value = "Ended"
        case .SwitchSetting_Button_1HourPassNotiDesc: value = "Every 1 hour passed"
        case .SwitchSetting_Button_NewVerNotiDesc: value = "Pop-up alert for New version"
        case .SwitchSetting_Button_TimeAnimationTitle: value = "Time change animation"
        case .SwitchSetting_Button_TimeAnimationDesc: value = "Smoothly Display time changes"
        case .SwitchSetting_Button_BigUITitle: value = "Big UI"
        case .SwitchSetting_Button_BigUIDesc: value = "Activate Big UI for iPad"
        case .SwitchSetting_Button_KeepScreenOnTitle: value = "Keep screen on"
        case .SwitchSetting_Button_KeepScreenOnDesc: value = "Keep the screen on during recording"
        case .SwitchSetting_Button_FlipStartTitle: value = "Flip to start recording"
        case .SwitchSetting_Button_FlipStartDesc: value = "Record will start automatically when flip the device"
            
        case .Language_Button_SystemLanguage: value = "System Language"
        case .Language_Button_Korean: value = "Korean"
        case .Language_Button_English: value = "English"
        case .Language_Button_Chinese: value = "Chinese, Simplified"
        case .Language_Popup_LanguageChangeTitle: value = "Language has been changed"
        case .Language_Popup_LanguageChangeDesc: value = "Please restart the app"
            
        case .ColorSelector_Text_Color: value = "Color"
        case .ColorSelector_Text_SetGraphColor: value = "Setting the color of the graph"
        case .ColorSelector_Text_SetWidgetColor: value = "Setting the color of the widget"
        case .ColorSelector_Text_ColorDirectionTitle: value = "Color direction"
        case .ColorSelector_Text_ColorDirectionDesc: value = "Setting the direction of the color combination"
            
        case .EmailMessage_Error_CantSendEmailTitle: value = "Email Failed"
        case .EmailMessage_Error_CantSendEmailDesc: value = "Please check the setting of iPhone's Email, and try again."
        case .EmailMessage_Text_Message: value = "Every little feedback helps a lot :)"
        case .EmailMessage_Text_FindNickname: value = "I need your registered email information to find your nickname.\n\nRegistered email: \n\nPlease fill in the above information and send it to us"
            
        case .Recording_Text_TargetTime: value = "Target Time"
        case .Recording_Text_TaskTargetTime: value = "Task Target Time"
        case .Recording_Text_SumTime: value = "Sum Time"
        case .Recording_Popup_NoTaskWarningTitle: value = "Create a new task"
        case .Recording_Popup_NoTaskWarningDesc: value = "before start recording, Create a new Task, and select that"
        case .Recording_Popup_CheckDailyDateTitle: value = "Check the date of recording"
        case .Recording_Popup_CheckDailyDateDesc: value = "Do you want to start the New record?"
        case .Recording_Text_EditTargetTimeTitle: value = "Edit Target Time"
            
        case .Timer_Text_Finish: value = "FINISH"
        case .Timer_Text_TimerEndTime: value = "End Time"
        case .Timer_Text_SetTimerTimeTitle: value = "Setting Timer Time"
            
        case .Tasks_Hint_NewTaskTitle: value = "New task"
        case .Tasks_Popup_NewTaskDesc: value = "Task name's max length is 20"
        case .Tasks_Popup_EditTaskName: value = "Modify task's name"
        case .Tasks_Text_SetTaskTargetTime: value = "Setted Target Time"
        case .Tasks_Popup_SameTaskExistTitle: value = "Same task exist"
        case .Tasks_Popup_SameTaskExistDesc: value = "Try to another task's name"
        case .Tasks_Popup_SetTaskTargetTime: value = "Setting Target Time"
            
        case .Todos_Popup_EditTodoName: value = "Modify Todo's content"
        case .Todos_Hint_TodoName: value = "New Todo's content"
        case .Todos_Popup_EditTodoGroupName: value = "Modify Group's Name"
        case .Todos_Hint_NewTodoGroupName: value = "New Group Name"
        case .Todos_Button_CreateTodoGroup: value = "Create Group"
        case .Todos_Button_DeleteTodoGroup: value = "Delete Group"
        case .Todos_Popup_DeleteTodoGroupTitle: value = "Delete {}"
        case .Todos_Popup_DeleteTodoGroupDesc: value = "Do you want to Delete {} group?"
            
        case .EditDaily_Popup_UnableEditTitle: value = "Unable to Modify Records"
        case .EditDaily_Popup_EditTaskName: value = "Modify Task Name"
        case .EditDaily_Popup_EnterTaskName: value = "Enter Task Name"
        case .EditDaily_Popup_EditTaskSaved: value = "Your changes have been saved."
        case .EditDaily_Popup_EditChangeCanceled: value = "Changes will be removed."
        case .EditDaily_Popup_SameTaskExist: value = "The same task name already exists."
        case .EditDaily_Popup_EditTaskNameDesc: value = "Please enter a new task"
        case .EditDaily_Text_InfoEnterTaskName: value = "Enter the new task's name"
        case .EditDaily_Text_StartAt: value = "StartAt"
        case .EditDaily_Text_EndAt: value = "EndAt"
        case .EditDaily_Text_InfoHowToEditDaily: value = "Select a task, edit the record\nand press the SAVE button"
        case .EditDaily_Text_InfoHowToCreateDaily: value = "Click a \"+ New Task\", create the record\nand press the SAVE button"
        case .EditDaily_Button_CreateNewTaskHistory: value = "New Task"
        case .EditDaily_Button_AppendNewHistory: value = "New History"
        case .EditDaily_Popup_WatchADRequired: value = "You have to watch the ad to save edited record. Would you like to watch?"
        case .EditDaily_Popup_UndableEditDesc: value = "Past format record can't editting, Please wait for update"
            
        case .LogSetting_Text_DailyTargetTimeDesc: value = "Setting the target time of Circular Progress Bar"
            
        case .RecordingColorSelector_Text_CustomColor: value = "Custom Color"
        case .RecordingColorSelector_Text_BackgroundColor: value = "Background"
        case .RecordingColorSelector_Text_TextColor: value = "TextColor"
            
        case .SignIn_Text_TimerTiTi: value = "TimerTiTi"
        case .SignIn_Button_SocialSignIn: value = "Sign in with {}"
        case .SignIn_Button_WithoutSocialSingIn: value = "Using without Sign in"
        case .SignIn_Hint_Email: value = "Email"
        case .SignIn_Hint_Password: value = "Password"
        case .SignIn_Button_TiTiSingIn: value = "Sign In"
        case .SignIn_Text_OR: value = "OR"
        case .SignIn_Button_FindEmail: value = "Forgot Email?"
        case .SignIn_Button_FindPassword: value = "Forgot Password?"
        case .SignIn_Button_FindNickname: value = "Forgot Nickname?"
        case .SignIn_Button_Contect: value = "Contect"
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
            
        case .FindAccount_Text_InputNicknameDesc: value = "Please enter your nickname for the registered account"
        case .FindAccount_Error_NotRegisteredNickname: value = "This nickname is not registered"
        case .FindAccount_Text_InputEmailDesc: value = "Please enter your email for the registered account"
        case .FindAccount_Error_NotRegisteredEmail: value = "This email is not registered"
        case .FindAccount_Text_InputNewPasswordTitle: value = "Please enter a new password"
        case .FindAccount_Error_NotRegisteredNicknameEmail: value = "User corresponding to nickname and email does not exist.\nPlease check again"
        case .FindAccount_Text_ChangeCompletedTitle: value = "Change completed!"
        case .FindAccount_Text_ChangePasswordCompleted: value = "Password has been changed!"
        case .FindAccount_Button_GoToLogin: value = "Go to Signin"
            
        case .Server_Popup_ServerCantUseTitle: value = "The server is temporarily unavailable"
        case .Server_Popup_ServerCantUseDesc: value = "Please try it later :)"
        case .Server_Error_NetworkError: value = "Network Error"
        case .Server_Error_NetworkTimeout: value = "Network Timeout"
        case .Server_Error_NetworkFetchError: value = "Network Fetch Error"
        case .Server_Error_ServerError: value = "Server Error"
        case .Server_Error_CheckNetwork: value = "Please check the network and try again"
        case .Server_Error_DecodeError: value = "Please update to the latest version of the app"
        case .Server_Error_ServerErrorTryAgain: value = "The server something went wrong. Please try again in a few minutes"
        case .Server_Error_UploadError: value = "Upload Error"
        case .Server_Error_DownloadError: value = "Download Error"
            
        case .Notification_Button_PassToday: value = "Dismiss for Today"
        case .Notification_Button_PassWeek: value = "Dismiss for a week"
            
        case .WidgetSetting_Text_DailyTargetTimeDesc: value = "Setting the target time for color density display based on total time by date"
        case .WidgetSetting_Text_Description: value = "About Widget"
        case .WidgetSetting_Button_AddMethod: value = "How to add Widget"
        case .WidgetSetting_Text_WidgetDesc1: value = "Touch and hold an empty area on your Home Screen until the apps jiggle."
        case .WidgetSetting_Text_WidgetDesc2: value = "Tap the ( + ) button in the upper corner."
        case .WidgetSetting_Text_WidgetDesc3: value = "Search for \"TiTi\" and Tap."
        case .WidgetSetting_Text_WidgetDesc4: value = "Select a Widget and size, then Tap \"Add Widget\"."
        case .WidgetSetting_Text_WidgetDesc5: value = "Now you can use Widget!"
            
        case .Widget_Text_CalendarWidget: value = "Calendar widget"
        case .Widget_Text_CalendarWidgetDesc: value = "Widget shows the top 5 tasks and the recording time by date."
        case .Widget_Text_InfoNoRecords: value = "There's no record this month!"
        case .Widget_Text_SampleTask1: value = "Work"
        case .Widget_Text_SampleTask2: value = "Reading"
        case .Widget_Text_SampleTask3: value = "Coding"
        case .Widget_Text_SampleTask4: value = "Study"
        case .Widget_Text_SampleTask5: value = "Workout"
            
        case .Toast_Text_NewRecord: value = "Start Recording!"
        }
        
        if let op = op, value.contains("{}") {
            value = value.replacingOccurrences(of: "{}", with: "\(op)")
        }
        
        return value
    }
}
