//
//  ModifyFinishButton.swift
//  Project_Timer
//
//  Created by 최수정 on 2022/08/16.
//  Copyright © 2022 FDEE. All rights reserved.
//

import UIKit

final class ModifyFinishButton: UIButton {
    override var isEnabled: Bool {
        didSet {
            if isEnabled {
                self.backgroundColor = UIColor(named: String.userTintColor)
            } else {
                self.backgroundColor = UIColor.systemGray5
            }
        }
    }
    
    convenience init() {
        self.init(frame: CGRect())
        
        self.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.heightAnchor.constraint(equalToConstant: 30),
            self.widthAnchor.constraint(equalToConstant: 70)
        ])
        self.cornerRadius = 6
        self.setTitleColor(UIColor.label, for: .normal)
        self.setTitleColor(UIColor.systemGray2, for: .disabled)
        self.titleLabel?.font = Fonts.HGGGothicssiP60g(size: 18)
    }
}
