//
//  CategoryLabel.swift
//  Project_Timer
//
//  Created by 최수정 on 2022/08/16.
//  Copyright © 2022 FDEE. All rights reserved.
//

import UIKit

class CategoryLabel: UILabel {
    convenience init(title: String) {
        self.init(frame: CGRect())
        
        self.translatesAutoresizingMaskIntoConstraints = false
        self.text = title
        self.font = TiTiFont.HGGGothicssiP60g(size: 16)
        self.textColor = UIColor.label
    }
}
