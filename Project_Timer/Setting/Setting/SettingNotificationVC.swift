//
//  SettingNotificationVC.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2023/05/20.
//  Copyright © 2023 FDEE. All rights reserved.
//

import UIKit

final class SettingNotificationVC: UIViewController {
    static let identifier = "SettingNotificationVC"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Notification".localized()
        self.view.backgroundColor = .systemBackground
    }
}
