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
        let padding: CGFloat = 12
        if #available(macCatalyst 15.0, *) {
            self.configuration?.contentInsets = .init(top: padding, leading: padding, bottom: padding, trailing: padding)
        } else {
            self.contentEdgeInsets = .init(top: padding, left: padding, bottom: padding, right: padding)
        }
        NSLayoutConstraint.activate([
            self.widthAnchor.constraint(equalToConstant: 50),
            self.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
}
