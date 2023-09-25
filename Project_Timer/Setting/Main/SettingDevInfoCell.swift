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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.email.setImage(UIImage(named: "email")?.withRenderingMode(.alwaysTemplate), for: .normal)
        self.instagram.setImage(UIImage(named: "instagram")?.withRenderingMode(.alwaysTemplate), for: .normal)
        self.github.setImage(UIImage(named: "github")?.withRenderingMode(.alwaysTemplate), for: .normal)
    }
    
    @IBAction func showEmail(_ sender: Any) {
        self.delegate?.systemVC(destination: .mail)
    }
    
    @IBAction func showInstagram(_ sender: Any) {
        self.delegate?.showOtherApp(destination: .website(url: NetworkURL.instagramToTiTi))
    }
    
    @IBAction func showGithub(_ sender: Any) {
        self.delegate?.showOtherApp(destination: .website(url: NetworkURL.github))
    }
}

