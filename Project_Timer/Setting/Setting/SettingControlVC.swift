//
//  SettingControlVC.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2023/05/20.
//  Copyright © 2023 FDEE. All rights reserved.
//

import UIKit

final class SettingControlVC: UIViewController {
    static let identifier = "SettingControlVC"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Control".localized()
        self.view.backgroundColor = .systemBackground
    }
}
