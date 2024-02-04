//
//  SettingSwitchListVM.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2023/05/20.
//  Copyright © 2023 FDEE. All rights reserved.
//

import Foundation

final class SettingSwitchListVM {
    enum DataSource: String {
        case notification
        case ui
        case control
    }
    let title: String
    private(set) var cells: [SettingListCellInfo]
    
    init(isIpad: Bool, dataSource: DataSource) {
        switch dataSource {
        case .notification:
            self.title = Localized.string(.Settings_Button_Notification)
            self.cells = [
                SettingListCellInfo(title: Localized.string(.Common_Text_Timer), subTitle: Localized.string(.SwitchSetting_Button_5minNotiDesc), toggleKey: .timer5minPushable),
                SettingListCellInfo(title: Localized.string(.Common_Text_Timer), subTitle: Localized.string(.SwitchSetting_Button_EndNotiDesc), toggleKey: .timerPushable),
                SettingListCellInfo(title: Localized.string(.Common_Text_Stopwatch), subTitle: Localized.string(.SwitchSetting_Button_1HourPassNotiDesc), toggleKey: .stopwatchPushable),
                SettingListCellInfo(title: Localized.string(.SwitchSetting_Button_Update), subTitle: Localized.string(.SwitchSetting_Button_NewVerNotiDesc), toggleKey: .updatePushable)
            ]
        case .ui:
            self.title = Localized.string(.Settings_Button_UI)
            self.cells = [
                SettingListCellInfo(title: Localized.string(.SwitchSetting_Button_TimeAnimationTitle), subTitle: Localized.string(.SwitchSetting_Button_TimeAnimationDesc), toggleKey: .timelabelsAnimation)
            ]
            if isIpad {
                self.cells.append(SettingListCellInfo(title: Localized.string(.SwitchSetting_Button_BigUITitle), subTitle: Localized.string(.SwitchSetting_Button_BigUIDesc), toggleKey: .bigUI))
            }
        case .control:
            self.title = Localized.string(.Settings_Button_Control)
            self.cells = [
                SettingListCellInfo(title: Localized.string(.SwitchSetting_Button_KeepScreenOnTitle), subTitle: Localized.string(.SwitchSetting_Button_KeepScreenOnDesc), toggleKey: .keepTheScreenOn),
                SettingListCellInfo(title: Localized.string(.SwitchSetting_Button_FlipStartTitle), subTitle: Localized.string(.SwitchSetting_Button_FlipStartDesc), toggleKey: .flipToStartRecording)
            ]
        }
        
    }
}
