//
//  LeftButton.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2023/01/07.
//  Copyright © 2023 FDEE. All rights reserved.
//

import UIKit

final class LeftButton: UIButton {
    convenience init() {
        self.init(frame: CGRect())
        self.translatesAutoresizingMaskIntoConstraints = false
        self.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        self.tintColor = UIColor.label
        NSLayoutConstraint.activate([
            self.widthAnchor.constraint(equalToConstant: 26),
            self.heightAnchor.constraint(equalToConstant: 26)
        ])
    }
}
