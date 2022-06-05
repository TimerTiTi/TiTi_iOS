//
//  SurveyCell.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2022/06/05.
//  Copyright © 2022 FDEE. All rights reserved.
//

import UIKit

final class SurveyCell: UICollectionViewCell {
    static let identifier = "SurveyCell"
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var touchableMark: UIImageView!
    @IBOutlet weak var warningLabel: UILabel!
}
