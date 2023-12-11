//
//  ThemeColorDirectionView.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2023/05/21.
//  Copyright © 2023 FDEE. All rights reserved.
//

import UIKit

final class ThemeColorDirectionView: UIView {
    private weak var delegate: Updateable?
    private var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Fonts.HGGGothicssiP60g(size: 17)
        label.textColor = .label
        label.textAlignment = .left
        return label
    }()
    private var subTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Fonts.HGGGothicssiP60g(size: 11)
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
    private var colorDirectionSelector: UISegmentedControl = {
        let selector = UISegmentedControl(items: ["→", "←"])
        selector.translatesAutoresizingMaskIntoConstraints = false
        selector.selectedSegmentTintColor = UIColor(named: String.userTintColor)
        return selector
    }()
    private var colorView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 8
        view.layer.cornerCurve = .continuous
        view.clipsToBounds = true
        view.backgroundColor = UIColor(named: String.userTintColor)
        return view
    }()
    private var colorKey: UserDefaultsManager.Keys = .startColor
    private var directionKey: UserDefaultsManager.Keys = .reverseColor
    
    convenience init(delegate: Updateable, colorKey: UserDefaultsManager.Keys, directionKey: UserDefaultsManager.Keys) {
        self.init(frame: CGRect())
        self.delegate = delegate
        self.colorKey = colorKey
        self.directionKey = directionKey
        self.configure()
        self.configureDirectionSelector()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.updateColor()
    }
    
    private func configure() {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.titleLabel.text = "Color direction".localized()
        self.subTitleLabel.text = "Setting the direction of the color combination".localized()
        
        self.addSubview(self.titleStackView)
        NSLayoutConstraint.activate([
            self.titleStackView.topAnchor.constraint(equalTo: self.topAnchor),
            self.titleStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16)
        ])
        
        self.addSubview(self.colorDirectionSelector)
        NSLayoutConstraint.activate([
            self.colorDirectionSelector.topAnchor.constraint(equalTo: self.titleStackView.bottomAnchor, constant: 16),
            self.colorDirectionSelector.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            self.colorDirectionSelector.widthAnchor.constraint(equalToConstant: 80),
            self.colorDirectionSelector.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
        
        self.addSubview(self.colorView)
        NSLayoutConstraint.activate([
            self.colorView.widthAnchor.constraint(equalTo: self.colorDirectionSelector.widthAnchor, multiplier: 1),
            self.colorView.heightAnchor.constraint(equalTo: self.colorDirectionSelector.heightAnchor, multiplier: 1),
            self.colorView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            self.colorView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
    
    private func configureDirectionSelector() {
        self.colorDirectionSelector.addTarget(self, action: #selector(update(_:)), for: .allEvents)
        let isReverseColor = UserDefaultsManager.get(forKey: self.directionKey) as? Bool ?? false
        self.colorDirectionSelector.selectedSegmentIndex = isReverseColor ? 1 : 0
    }
    
    @objc func update(_ sender: UISegmentedControl) {
        let isReverseColor = sender.selectedSegmentIndex == 1
        UserDefaultsManager.set(to: isReverseColor, forKey: self.directionKey)
        self.delegate?.update()
    }
    
    private func setGradient(view: UIView, color1: UIColor, color2: UIColor) {
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.colors = [color1.cgColor, color2.cgColor]
        gradient.locations = [0.0, 1.0]
        gradient.startPoint = CGPoint(x: 0.0, y: 1.0)
        gradient.endPoint = CGPoint(x: 1.0, y: 1.0)
        gradient.frame = view.bounds
        view.layer.addSublayer(gradient)
    }
}

extension ThemeColorDirectionView {
    func updateColor() {
        let isReverseColor = self.colorDirectionSelector.selectedSegmentIndex == 1
        let colorNum = UserDefaultsManager.get(forKey: self.colorKey) as? Int ?? 1
        var nextColorNum: Int = isReverseColor ? (colorNum+12-1)%12 : (colorNum+1)%12
        if nextColorNum == 0 { nextColorNum = 12 }
        
        let color1 = UIColor(named: "D\(colorNum)") ?? .blue
        let color2 = UIColor(named: "D\(nextColorNum)") ?? .blue
        
        self.colorDirectionSelector.selectedSegmentTintColor = color1
        self.setGradient(view: self.colorView, color1: color1, color2: color2)
    }
}
