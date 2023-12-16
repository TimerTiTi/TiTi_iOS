//
//  SettingListCellInfo.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2023/05/20.
//  Copyright © 2023 FDEE. All rights reserved.
//

import Foundation

struct SettingListCellInfo {
    let title: String
    var subTitle: String?
    var rightTitle: String?
    var switchable: Bool = false
    var toggleKey: UserDefaultsManager.Keys? = nil
    var cellHeight: Int {
        return self.subTitle != nil ? 64 : 55
    }
    
    init(title: String, subTitle: String, toggleKey: UserDefaultsManager.Keys) {
        self.title = title
        self.subTitle = subTitle
        self.toggleKey = toggleKey
        self.switchable = true
    }
}
