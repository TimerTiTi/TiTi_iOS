//
//  SettingHeaderView.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2022/06/01.
//  Copyright © 2022 FDEE. All rights reserved.
//

import UIKit

final class SettingHeaderView: UICollectionReusableView {
    static let identifier = "SettingHeaderView"
    
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.titleLabel.font = Typographys.uifont(.semibold_4, size: 14)
    }
    
    func configure(title: String) {
        self.titleLabel.text = title
    }
}
