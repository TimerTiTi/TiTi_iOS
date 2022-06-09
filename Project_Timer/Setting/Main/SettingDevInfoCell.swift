//
//  SettingDevInfoCell.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2022/06/09.
//  Copyright © 2022 FDEE. All rights reserved.
//

import UIKit

final class SettingDevInfoCell: UICollectionViewCell {
    static let identifier = "SettingDevInfoCell"
    
    @IBOutlet weak var email: UIButton!
    @IBOutlet weak var instagram: UIButton!
    @IBOutlet weak var github: UIButton!
    
    weak var delegate: SettingActionDelegate?
    
    @IBAction func showEmail(_ sender: Any) {
        print("showEmail")
    }
    
    @IBAction func showInstagram(_ sender: Any) {
        print("showInstagram")
    }
    
    @IBAction func showGithub(_ sender: Any) {
        print("showGithub")
    }
}

