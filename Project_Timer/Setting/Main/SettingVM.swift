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
    private(set) var sections: [String] = []
    private let isIpad: Bool
    
    init(isIpad: Bool) {
        self.isIpad = isIpad
        self.configureSections()
        self.configureCells()
    }
    
    private func configureSections() {
        self.sections.append("Service".localized())
        self.sections.append("Setting".localized())
        self.sections.append("Version & Update history".localized())
        self.sections.append("Backup".localized())
        self.sections.append("Developer".localized())
    }
    
    private func configureCells() {
        let versionCell = SettingCellInfo(title: "Version Info".localized(), subTitle: "Latest version".localized()+":", rightTitle: String.currentVersion, link: NetworkURL.appstore)
        versionCell.fetchVersion()
        
        var cells: [[SettingCellInfo]] = []
        // Service
        cells.append([
            SettingCellInfo(title: "TiTi Functions".localized(), nextVCIdentifier: SettingFunctionsListVC.identifier),
            SettingCellInfo(title: "TiTi Lab".localized(), nextVCIdentifier: SettingTiTiLabVC.identifier)
        ])
        // Setting
        cells.append([
            SettingCellInfo(title: "Notification".localized(), vc: .notification),
            SettingCellInfo(title: "UI", vc: .ui),
            SettingCellInfo(title: "Control".localized(), vc: .control),
        ])
        #if targetEnvironment(macCatalyst)
        cells.last?.remove(at: 2) // Control 제거
        #endif
        // Version & Update history
        cells.append([
            versionCell,
            SettingCellInfo(title: "Update history".localized(), nextVCIdentifier: SettingUpdateHistoryVC.identifier)
        ])
        // Backup
        cells.append([
            SettingCellInfo(title: "Get JSON files".localized(), nextVCIdentifier: "showBackup")
        ])
        // Developer
        cells.append([
            SettingCellInfo(title: "FDEE")
        ])
        
        self.cells = cells
    }
}
