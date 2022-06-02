//
//  SettingCellInfo.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2022/06/01.
//  Copyright © 2022 FDEE. All rights reserved.
//

import Foundation

struct SettingCellInfo {
    var cellHeight: Int {
        return self.subTitle != nil ? 60 : 47
    }
    let title: String
    var subTitle: String? = nil
    var rightTitle: String? = nil
    var touchable: Bool = true
    var switchable: Bool = false
    var toggleKey: String? = nil
    var action: SettingAction? = nil
    var nextVCIdentifier: String? = nil
    var url: String? = nil
    var iconName: String = "none"
    
    /// title  + pushVC
    init(title: String, nextVCIdentifier: String) {
        self.title = title
        self.nextVCIdentifier = nextVCIdentifier
    }
    /// title + subtitle + switch
    init(title: String, subTitle: String, toggleKey: String) {
        self.title = title
        self.subTitle = subTitle
        self.toggleKey = toggleKey
        self.switchable = true
        self.touchable = false
    }
    /// title + subtitle + righttitle + pushVC
    init(title: String, subTitle: String, rightTitle: String, nextVCIdentifier: String) {
        self.title = title
        self.subTitle = subTitle
        self.rightTitle = rightTitle
        self.nextVCIdentifier = nextVCIdentifier
        self.action = .pushVC
    }
    /// title + subtitle + righttitle + url
    init(title: String, subTitle: String, rightTitle: String, link: String) {
        self.title = title
        self.subTitle = subTitle
        self.rightTitle = rightTitle
        self.url = link
        self.action = .deeplink
    }
    /// title
    init(title: String) {
        self.title = title
        self.touchable = false
    }
}

enum SettingAction: String {
    case pushVC
    case goSafari
    case deeplink
}
