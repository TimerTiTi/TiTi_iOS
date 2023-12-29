//
//  SettingCell.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2022/06/01.
//  Copyright © 2022 FDEE. All rights reserved.
//

import UIKit

final class SettingCell: UICollectionViewCell {
    static let identifier = "SettingCell"
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    @IBOutlet weak var rightLabel: UILabel!
    @IBOutlet weak var touchableMark: UIImageView!
    private lazy var toggleSwitch: UISwitch = {
        let toggle = UISwitch()
        toggle.translatesAutoresizingMaskIntoConstraints = false
        toggle.isOn = true
        toggle.isHidden = true
        toggle.addTarget(self, action: #selector(switchValueDidChange(_:)), for: .valueChanged)
        return toggle
    }()
    @objc func switchValueDidChange(_ sender: UISwitch!) {
        guard let key = self.info?.toggleKey else { return }
        UserDefaultsManager.set(to: sender.isOn, forKey: key)
        self.toggleSwitch.setOn(sender.isOn, animated: true)
    }
    
    private var info: SettingCellInfo?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.configureUI()
        self.configureLocalized()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.toggleSwitch.isHidden = true
    }
    
    private func configureUI() {
        self.contentView.addSubview(self.toggleSwitch)
        
        NSLayoutConstraint.activate([
            self.toggleSwitch.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -16),
            self.toggleSwitch.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor)
        ])
    }
    
    private func configureUI(with info: SettingCellInfo) {
        self.titleLabel.text = info.title
        if let subTitle = info.subTitle {
            self.subTitleLabel.isHidden = false
            self.subTitleLabel.text = subTitle
        } else {
            self.subTitleLabel.isHidden = true
        }
        self.rightLabel.text = info.rightTitle != nil ? info.rightTitle : ""
        self.touchableMark.isHidden = !info.touchable
    }
    
    private func configureSwitchColor() {
        let color = UIColor(named: String.userTintColor)
        self.toggleSwitch.tintColor = color
        self.toggleSwitch.onTintColor = color
    }
    
    private func configureSwitch(key: UserDefaultsManager.Keys) {
        self.toggleSwitch.isHidden = false
        let value = UserDefaultsManager.get(forKey: key) as? Bool ?? true
        self.toggleSwitch.setOn(value, animated: false)
    }
    
    private func configureLocalized() {
        self.titleLabel.font = Typographys.uifont(.semibold_4, size: 17)
        self.subTitleLabel.font = Typographys.uifont(.semibold_4, size: 11)
        self.rightLabel.font = Typographys.uifont(.normal_3, size: 16)
    }
}

// MARK: Input
extension SettingCell {
    func configure(with info: SettingCellInfo) {
        self.info = info
        self.configureUI(with: info)
        
        if let key = info.toggleKey, info.switchable {
            self.configureSwitchColor()
            self.configureSwitch(key: key)
        }
    }
}
