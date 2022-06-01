//
//  SettingCell.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2022/06/01.
//  Copyright © 2022 FDEE. All rights reserved.
//

import UIKit

class SettingCell: UICollectionViewCell {
    static let identifier = "SettingCell"
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    @IBOutlet weak var rightLabel: UILabel!
    @IBOutlet weak var touchableMark: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    func configure(with info: SettingCellInfo) {
        self.titleLabel.text = info.title
        self.subTitleLabel.text = info.subTitle != nil ? info.subTitle : ""
        self.rightLabel.text = info.rightTitle != nil ? info.rightTitle : ""
        self.touchableMark.isHidden = !info.touchable
    }
}
