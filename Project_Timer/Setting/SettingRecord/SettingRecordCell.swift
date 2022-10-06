//
//  SettingRecordCell.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2022/10/06.
//  Copyright © 2022 FDEE. All rights reserved.
//

import UIKit

final class SettingRecordCell: UICollectionViewCell {
    static let identifier = "SettingRecordCell"
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    @IBOutlet weak var settedHourLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configure(info: SettingRecordCellInfo) {
        self.titleLabel.text = info.titleText
        self.subTitleLabel.text = info.subTitleText
        
        var settedHour: Int
        switch info.key {
        case .goalTimeOfMonth:
            settedHour = UserDefaultsManager.get(forKey: .goalTimeOfMonth) as? Int ?? 360000
        case .goalTimeOfWeek:
            settedHour = UserDefaultsManager.get(forKey: .goalTimeOfWeek) as? Int ?? 90000
        case .goalTimeOfDaily:
            settedHour = UserDefaultsManager.get(forKey: .goalTimeOfDaily) as? Int ?? 21600
        default:
            return
        }
        
        self.settedHourLabel.text = "\(settedHour/3600) H"
    }
}
