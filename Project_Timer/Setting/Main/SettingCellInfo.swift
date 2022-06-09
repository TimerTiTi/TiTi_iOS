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
    var nextVCIdentifier: String? = nil
    var url: String? = nil
    var iconName: String = "none"
    
    /// title  + pushVC
    init(title: String, nextVCIdentifier: String) {
        self.title = title
        self.nextVCIdentifier = nextVCIdentifier
        self.action = .pushVC
    }
    /// title + subtitle + switch
    init(title: String, subTitle: String, toggleKey: UserDefaultsManager.Keys) {
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
    
    func fetchVersion() {
        NetworkController(network: Network()).getAppstoreVersion { [weak self] status, version in
            guard status == .SUCCESS, let version = version else { return }
            self?.subTitle = "최신버전: \(version)"
        }
    }
}

enum SettingAction: String {
    case pushVC
    case goSafari
    case deeplink
}

protocol SettingActionDelegate: AnyObject {
    func pushVC(nextVCIdentifier: String)
    func goSafari(url: String)
    func deeplink(link: String)
}
