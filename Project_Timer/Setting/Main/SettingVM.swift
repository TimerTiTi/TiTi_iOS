//
//  SettingVM.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2022/06/01.
//  Copyright © 2022 FDEE. All rights reserved.
//

import Foundation
import Combine

final class SettingVM {
    @Published private(set) var cells: [[SettingCellInfo]] = []
    @Published private(set) var lastestVersionFetched: Bool = false
    private(set) var sections: [String] = []
    private let isIpad: Bool
    
    init(isIpad: Bool) {
        self.isIpad = isIpad
        self.configureSections()
        self.configureCells()
    }
    
    private func configureSections() {
        // MARK: Dev
        if Infos.isDevMode {
            self.sections.append("Profile".localized())
        }
        
        self.sections.append("Service".localized())
        self.sections.append("Setting".localized())
        self.sections.append("Version & Update history".localized())
        self.sections.append("Backup".localized())
        self.sections.append("Developer".localized())
    }
    
    private func configureCells() {
        let versionCell = SettingCellInfo(title: "Version Info".localized(), subTitle: "Latest version".localized()+":", rightTitle: String.currentVersion, action: .otherApp, destination: .deeplink(url: NetworkURL.appstore))
        
        var cells: [[SettingCellInfo]] = []
        // MARK: Dev
        if Infos.isDevMode {
            // Profile
            cells.append([
                SettingCellInfo(title: Localized.string(.Settings_Button_SingInOption), subTitle: Localized.string(.Settings_Button_SingInOptionDesc), action: .modalFullscreen, destination: .signinSelect)
            ])
        }
        
        // Service
        cells.append([
            SettingCellInfo(title: "TiTi Functions".localized(), action: .pushVC, destination: .storyboardName(identifier: SettingFunctionsListVC.identifier)),
            SettingCellInfo(title: "TiTi Lab".localized(), action: .pushVC, destination: .storyboardName(identifier: SettingTiTiLabVC.identifier))
        ])
        // Setting
        if Infos.isDevMode {
            cells.append([
                SettingCellInfo(title: "Notification".localized(), action: .pushVC, destination: .notification),
                SettingCellInfo(title: "UI", action: .pushVC, destination: .ui),
                SettingCellInfo(title: "Control".localized(), action: .pushVC, destination: .control),
                SettingCellInfo(title: Localized.string(.Settings_Button_LanguageOption), action: .pushVC, destination: .language),
                SettingCellInfo(title: "Widget".localized(), action: .pushVC, destination: .widget)
            ])
        } else {
            cells.append([
                SettingCellInfo(title: "Notification".localized(), action: .pushVC, destination: .notification),
                SettingCellInfo(title: "UI", action: .pushVC, destination: .ui),
                SettingCellInfo(title: "Control".localized(), action: .pushVC, destination: .control),
                SettingCellInfo(title: "Widget".localized(), action: .pushVC, destination: .widget)
            ])
        }
        #if targetEnvironment(macCatalyst)
        cells.last?.remove(at: 2) // Control 제거
        #endif
        // Version & Update history
        cells.append([
            versionCell,
            SettingCellInfo(title: "Update history".localized(), action: .pushVC, destination: .storyboardName(identifier: SettingUpdateHistoryVC.identifier))
        ])
        // Backup
        cells.append([
            SettingCellInfo(title: "Get Backup files".localized(), action: .activityVC, destination: .backup)
        ])
        // Developer
        cells.append([
            SettingCellInfo(title: "FDEE")
        ])
        
        self.cells = cells
        
//        NetworkController(network: Network()).getAppstoreVersion { [weak self] result in
//            switch result {
//            case .success(let version):
//                versionCell.updateSubTitle(to: "Latest version".localized()+": \(version)")
//                self?.lastestVersionFetched = true
//            case .failure(let error):
//                print(error.alertMessage)
//            }
//        }
    }
}
