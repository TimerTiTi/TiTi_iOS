//
//  InteractionViewPlaceholder.swift
//  Project_Timer
//
//  Created by 최수정 on 2022/08/16.
//  Copyright © 2022 FDEE. All rights reserved.
//

import UIKit

class TaskInteractionViewPlaceholder: UIView {
    private var messageLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Select a task, Edit the record\nand press the SAVE button".localized()
        label.numberOfLines = 2
        label.textAlignment = .center
        label.font = TiTiFont.HGGGothicssiP60g(size: 17)
        label.textColor = UIColor.label
        return label
    }()
    
    convenience init() {
        self.init(frame: CGRect())
        
        self.addSubview(messageLabel)
        NSLayoutConstraint.activate([
            self.messageLabel.topAnchor.constraint(equalTo: self.topAnchor),
            self.messageLabel.rightAnchor.constraint(equalTo: self.rightAnchor),
            self.messageLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            self.messageLabel.leftAnchor.constraint(equalTo: self.leftAnchor)
        ])
    }
}
