//
//  SettingLanguageVC.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2023/12/12.
//  Copyright © 2023 FDEE. All rights reserved.
//

import UIKit

final class SettingLanguageVC: UIViewController {
    static let identifier = "SettingLanguageVC"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = Localized.string(.Settings_Button_LanguageOption)
        self.view.backgroundColor = .systemGroupedBackground
        
    }
}
