//
//  NavigationBarInformationButton.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2023/05/26.
//  Copyright © 2023 FDEE. All rights reserved.
//

import UIKit

final class NavigationBarInformationButton: UIButton {
    convenience init() {
        self.init(frame: CGRect())
        self.configure()
    }
    
    private func configure() {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.setImage(UIImage.init(systemName: "info.circle"), for: .normal)
        self.setPreferredSymbolConfiguration(UIImage.SymbolConfiguration(pointSize: 20, weight: .medium, scale: .default), forImageIn: .normal)
        if #available(iOS 15.0, *) {
            self.tintColor = .tintColor
        } else {
            self.tintColor = .blue
        }
        self.contentMode = .scaleAspectFit
    }
}

