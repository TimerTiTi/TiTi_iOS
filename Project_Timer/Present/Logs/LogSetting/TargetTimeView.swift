//
//  TargetTimeView.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2023/05/21.
//  Copyright © 2023 FDEE. All rights reserved.
//

import UIKit

final class TargetTimeView: UIView {
    private var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Typographys.uifont(.semibold_4, size: 17)
        label.textColor = .label
        label.textAlignment = .left
        return label
    }()
    private var subTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Typographys.uifont(.semibold_4, size: 11)
        label.textColor = .lightGray
        label.textAlignment = .left
        label.numberOfLines = 0
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
    
    convenience init(text: String) {
        self.init(frame: CGRect())
        self.configure(text: text)
    }
    
    private func configure(text: String) {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.titleLabel.text = "Target time".localized()
        self.subTitleLabel.text = text
        
        self.addSubview(self.titleStackView)
        NSLayoutConstraint.activate([
            self.titleStackView.topAnchor.constraint(equalTo: self.topAnchor),
            self.titleStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            self.titleStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
}
