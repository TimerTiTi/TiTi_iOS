//
//  SettingRecordVC.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2022/09/29.
//  Copyright © 2022 FDEE. All rights reserved.
//

import UIKit

final class SettingRecordVC: UIViewController {
    static let identifier = "SettingRecordVC"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Target Times".localized()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate { [weak self] _ in
            //
        }
    }
}
