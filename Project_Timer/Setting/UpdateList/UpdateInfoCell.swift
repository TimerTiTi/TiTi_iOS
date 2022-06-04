//
//  UpdateInfoCell.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2022/06/04.
//  Copyright © 2022 FDEE. All rights reserved.
//

import UIKit

final class UpdateInfoCell: UICollectionViewCell {
    static let identifier = "UpdateInfoCell"
    
    @IBOutlet weak var versionLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var textLabel: UILabel!
    
    func configure(with info: UpdateInfo) {
        self.versionLabel.text = "ver: \(info.version)"
        self.dateLabel.text = "date: \(info.date)"
        self.textLabel.text = info.text
    }
}
