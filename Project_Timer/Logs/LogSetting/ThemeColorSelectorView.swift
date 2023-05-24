//
//  ThemeColorSelectorView.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2023/05/21.
//  Copyright © 2023 FDEE. All rights reserved.
//

import UIKit

final class ThemeColorSelectorView: UIView {
    private weak var delegate: Updateable?
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
    private lazy var colorStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = self.colorSpacing
        stackView.alignment = .center
        return stackView
    }()
    private var colorSpacing: CGFloat = 5
    private var key: UserDefaultsManager.Keys = .startColor
    
    convenience init(delegate: Updateable, key: UserDefaultsManager.Keys) {
        self.init(frame: CGRect())
        self.delegate = delegate
        self.key = key
        self.configure()
        
        if key == .calendarWidgetColor {
            self.subTitleLabel.text = "Setting the color of the widget".localized()
        }
    }
    
    private func configure() {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.titleLabel.text = "Color".localized()
        self.subTitleLabel.text = "Setting the color of the graph".localized()
        
        self.addSubview(self.titleStackView)
        NSLayoutConstraint.activate([
            self.titleStackView.topAnchor.constraint(equalTo: self.topAnchor),
            self.titleStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16)
        ])
        
        self.addSubview(self.colorStackView)
        NSLayoutConstraint.activate([
            self.colorStackView.topAnchor.constraint(equalTo: self.titleStackView.bottomAnchor, constant: 16),
            self.colorStackView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            self.colorStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])

        self.configureColorButtons()
    }
    
    private func configureColorButtons() {
        // MARK: Button Size
        let windowWidth: CGFloat = min(SceneDelegate.sharedWindow?.bounds.width ?? 390, SceneDelegate.sharedWindow?.bounds.height ?? 844)
        let width: CGFloat = min(windowWidth, 439) - (16*2)
        let margins: CGFloat = self.colorSpacing*(12-1)
        let buttonSize: CGFloat = CGFloat(width - margins)/CGFloat(12)
        
        for i in 1...12 {
            let colorButton = ColorButton(num: i)
            colorButton.addAction(UIAction(handler: { [weak self] _ in
                self?.updateColor(to: i)
            }), for: .touchUpInside)
            NSLayoutConstraint.activate([
                colorButton.widthAnchor.constraint(equalToConstant: buttonSize),
                colorButton.heightAnchor.constraint(equalToConstant: buttonSize)
            ])
            self.colorStackView.addArrangedSubview(colorButton)
        }
    }
    
    private func updateColor(to color: Int) {
        UserDefaultsManager.set(to: color, forKey: self.key)
        self.delegate?.update()
    }
}
