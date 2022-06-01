//
//  SettingCellInfo.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2022/06/01.
//  Copyright © 2022 FDEE. All rights reserved.
//

import Foundation

struct SettingCellInfo {
    let title: String
    let subTitle: String?
    let rightTitle: String?
    let touchable: Bool
    let switchable: Bool
    var cellHeight: Int {
        return self.subTitle != nil ? 60 : 47
    }
}
