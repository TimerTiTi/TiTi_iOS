//
//  SettingCellInfo.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2022/06/01.
//  Copyright © 2022 FDEE. All rights reserved.
//

import Foundation

class SettingCellInfo {
    var cellHeight: Int {
        return self.subTitle != nil ? 64 : 55
    }
    let title: String
    var subTitle: String? = nil
    var rightTitle: String? = nil
    var touchable: Bool = true
    var switchable: Bool = false
    var toggleKey: UserDefaultsManager.Keys? = nil
    var action: SettingAction? = nil
    var destination: Destination? = nil
    
    /// title (subTitle, rightTitle)
    init(title: String, subTitle: String? = nil, rightTitle: String? = nil) {
        self.title = title
        self.subTitle = subTitle
        self.rightTitle = rightTitle
        self.touchable = false
    }
    /// title (subTitle, rightTitle) + destination
    init(title: String, subTitle: String? = nil, rightTitle: String? = nil, action: SettingAction, destination: Destination) {
        self.title = title
        self.subTitle = subTitle
        self.rightTitle = rightTitle
        self.action = action
        self.destination = destination
    }
    /// title (subTitle) + switch
    init(title: String, subTitle: String? = nil, toggleKey: UserDefaultsManager.Keys) {
        self.title = title
        self.subTitle = subTitle
        self.toggleKey = toggleKey
        self.switchable = true
        self.touchable = false
    }
    
    func updateSubTitle(to subTitle: String) {
        self.subTitle = subTitle
    }
}

/// Cell 클릭 이벤트
enum SettingAction: String {
    case pushVC
    case modalFullscreen
    case activityVC
    case otherApp
}

/// push
enum Destination {
    case storyboardName(identifier: String)
    case website(url: String)
    case deeplink(url: String)
    // class 분기처리
    case notification
    case ui
    case control
    case widget
    case loginSelect
    // other app 분기처리
    case backup
    case mail
}

protocol SettingActionDelegate: AnyObject {
    func pushVC(identifier: String)
    func pushVC(destination: Destination)
    func modalVC(fullscreen: Bool, destination: Destination)
    func systemVC(destination: Destination)
    func showOtherApp(destination: Destination)
}
