//
//  ColorButton.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2023/05/21.
//  Copyright © 2023 FDEE. All rights reserved.
//

import UIKit

final class ColorButton: UIButton {
    convenience init(num: Int) {
        self.init(frame: CGRect())
        self.configure(num: num)
    }
    
    private func configure(num: Int) {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.layer.cornerRadius = 5
        self.layer.cornerCurve = .continuous
        self.backgroundColor = UIColor(named: "D\(num)")
        self.tag = num
    }
}
