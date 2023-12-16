//
//  SubjectCell.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2022/03/14.
//  Copyright © 2022 FDEE. All rights reserved.
//

import UIKit

class SubjectCell: UICollectionViewCell {
    static let identifier = "SubjectCell"
    
    @IBOutlet var colorView: UIView!
    @IBOutlet var taskName: UILabel!
    @IBOutlet var taskTime: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.colorView.layer.cornerRadius = 2
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    func configure(color: UIColor, nameAndTime: (name: String, time: String)) {
        self.colorView.backgroundColor = color
        self.taskName.textColor = color
        self.taskTime.textColor = color
        self.taskName.text = nameAndTime.name
        self.taskTime.text = nameAndTime.time
    }
}
