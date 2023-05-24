//
//  LogTargetTimeView.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2023/05/21.
//  Copyright © 2023 FDEE. All rights reserved.
//

import UIKit

final class LogTargetTimeView: UIView {
    private var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = TiTiFont.HGGGothicssiP60g(size: 17)
        label.textColor = .label
        label.textAlignment = .left
        return label
    }()
    private var subTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = TiTiFont.HGGGothicssiP60g(size: 11)
        label.textColor = .lightGray
        label.textAlignment = .left
        return label
    }()
    private lazy var titleStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [self.titleLabel, self.subTitleLabel])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 5
        stackView.alignment = .leading
        return stackView
    }()
    
    convenience init() {
        self.init(frame: CGRect())
        self.configure()
    }
    
    private func configure() {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.titleLabel.text = "Target time".localized()
        self.subTitleLabel.text = "Setting the target time of Circular Progress Bar".localized()
        
        self.addSubview(self.titleStackView)
        NSLayoutConstraint.activate([
            self.titleStackView.topAnchor.constraint(equalTo: self.topAnchor),
            self.titleStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            self.titleStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
}
