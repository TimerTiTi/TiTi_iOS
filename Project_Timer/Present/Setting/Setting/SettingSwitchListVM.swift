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
                SettingListCellInfo(title: Localized.string(.Common_Button_Timer), subTitle: Localized.string(.SwitchSetting_Button_5minNotiDesc), toggleKey: .timer5minPushable),
                SettingListCellInfo(title: Localized.string(.Common_Button_Timer), subTitle: Localized.string(.SwitchSetting_Button_EndNotiDesc), toggleKey: .timerPushable),
                SettingListCellInfo(title: Localized.string(.Common_Button_Stopwatch), subTitle: Localized.string(.SwitchSetting_Button_1HourPassNotiDesc), toggleKey: .stopwatchPushable),
                SettingListCellInfo(title: Localized.string(.SwitchSetting_Button_Update), subTitle: Localized.string(.SwitchSetting_Button_NewVerNotiDesc), toggleKey: .updatePushable)
            ]
        case .ui:
            self.title = Localized.string(.Settings_Button_UI)
            self.cells = [
                SettingListCellInfo(title: Localized.string(.SwitchSetting_Button_TimeAnimationTitle), subTitle: Localized.string(.SwitchSetting_Button_TimeAnimationDesc), toggleKey: .timelabelsAnimation)
            ]
            if isIpad {
                self.cells.append(SettingListCellInfo(title: "Big UI", subTitle: "Activate Big UI for iPad".localized(), toggleKey: .bigUI))
            }
        case .control:
            self.title = Localized.string(.Settings_Button_Control)
            self.cells = [
                SettingListCellInfo(title: "Keep screen on".localized(), subTitle: "Keep the screen on during recording".localized(), toggleKey: .keepTheScreenOn),
                SettingListCellInfo(title: "Flip to start recording".localized(), subTitle: "Record will start automatically when flip the device".localized(), toggleKey: .flipToStartRecording)
            ]
        }
        
    }
}
