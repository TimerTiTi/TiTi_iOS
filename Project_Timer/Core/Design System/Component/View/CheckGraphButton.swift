//
//  CheckGraphButton.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2022/07/17.
//  Copyright © 2022 FDEE. All rights reserved.
//

import UIKit

final class CheckGraphButton: UIButton {
    enum ImageName: String {
        case selected = "checkmark.circle.fill"
        case deSelected = "checkmark.circle"
    }
    
    convenience init() {
        self.init(frame: CGRect())
        self.translatesAutoresizingMaskIntoConstraints = false
        let config = UIImage.SymbolConfiguration(pointSize: 25, weight: .regular, scale: .default)
        let image = UIImage(systemName: ImageName.deSelected.rawValue, withConfiguration: config)
        self.setImage(image, for: .normal)
        self.tintColor = UIColor.label
        
        NSLayoutConstraint.activate([
            self.widthAnchor.constraint(equalToConstant: 25),
            self.heightAnchor.constraint(equalToConstant: 25)
        ])
    }
    
    override var isSelected: Bool {
        didSet {
            if isSelected {
                self.changeImage(to: .selected)
            } else {
                self.changeImage(to: .deSelected)
            }
        }
    }
    
    private func changeImage(to name: ImageName) {
        let config = UIImage.SymbolConfiguration(pointSize: 25, weight: .regular, scale: .default)
        let image = UIImage(systemName: name.rawValue, withConfiguration: config)
        self.setImage(image, for: .normal)
    }
}
