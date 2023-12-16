//
//  CloseButton.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2023/05/26.
//  Copyright © 2023 FDEE. All rights reserved.
//

import UIKit

final class CloseButton: UIButton {
    convenience init() {
        self.init(frame: CGRect())
        self.configure()
    }
    
    private func configure() {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.setImage(UIImage.init(systemName: "xmark"), for: .normal)
        self.setPreferredSymbolConfiguration(.init(pointSize: 18, weight: .regular, scale: .large), forImageIn: .normal)
        self.tintColor = .label
        
        NSLayoutConstraint.activate([
            self.widthAnchor.constraint(equalToConstant: 22),
            self.heightAnchor.constraint(equalToConstant: 22)
        ])
    }
}
