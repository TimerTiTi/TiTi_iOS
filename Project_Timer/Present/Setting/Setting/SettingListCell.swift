//
//  SettingListCell.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2023/05/20.
//  Copyright © 2023 FDEE. All rights reserved.
//

import UIKit

final class SettingListCell: UICollectionViewCell {
    static let identifier = "SettingListCell"
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
        return label
    }()
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [self.titleLabel, self.subTitleLabel])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 5
        stackView.alignment = .leading
        return stackView
    }()
    private lazy var toggleSwitch: UISwitch = {
        let toggle = UISwitch()
        toggle.translatesAutoresizingMaskIntoConstraints = false
        toggle.isOn = true
        toggle.addTarget(self, action: #selector(switchValueDidChange(_:)), for: .valueChanged)
        return toggle
    }()
    
    private var info: SettingListCellInfo?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    private func configure() {
        self.backgroundColor = .secondarySystemGroupedBackground
        self.contentView.backgroundColor = .clear
        
        self.contentView.addSubview(self.stackView)
        NSLayoutConstraint.activate([
            self.stackView.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor),
            self.stackView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 16)
        ])
        
        self.contentView.addSubview(self.toggleSwitch)
        
        NSLayoutConstraint.activate([
            self.toggleSwitch.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -16),
            self.toggleSwitch.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor)
        ])
    }
}

extension SettingListCell {
    func configure(info: SettingListCellInfo) {
        self.info = info
        self.titleLabel.text = info.title
        if let subTitle = info.subTitle {
            self.subTitleLabel.isHidden = false
            self.subTitleLabel.text = subTitle
        } else {
            self.subTitleLabel.isHidden = true
        }
        
        if let key = info.toggleKey {
            self.configureSwitch(key: key)
        }
    }
    
    private func configureSwitch(key: UserDefaultsManager.Keys) {
        let value = UserDefaultsManager.get(forKey: key) as? Bool ?? true
        self.toggleSwitch.setOn(value, animated: false)
        
        let color = UIColor(named: String.userTintColor)
        self.toggleSwitch.tintColor = color
        self.toggleSwitch.onTintColor = color
    }
    
    @objc func switchValueDidChange(_ sender: UISwitch!) {
        guard let key = self.info?.toggleKey else { return }
        
        UserDefaultsManager.set(to: sender.isOn, forKey: key)
        self.toggleSwitch.setOn(sender.isOn, animated: true)
    }
}
