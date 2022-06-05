//
//  SettingCell.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2022/06/01.
//  Copyright © 2022 FDEE. All rights reserved.
//

import UIKit

class SettingCell: UICollectionViewCell {
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
    
    private weak var delegate: SettingActionDelegate?
    private var info: SettingCellInfo?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.contentView.addSubview(self.toggleSwitch)
        
        NSLayoutConstraint.activate([
            self.toggleSwitch.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -16),
            self.toggleSwitch.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor)
        ])
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.toggleSwitch.isHidden = true
    }
    
    override var isSelected: Bool {
        didSet {
            if isSelected {
                self.touchAction()
            }
        }
    }
    
    func configure(with info: SettingCellInfo, delegate: SettingActionDelegate) {
        self.delegate = delegate
        self.info = info
        self.configureUI(with: info)
        
        if let key = info.toggleKey, info.switchable {
            self.configureSwitchColor()
            self.configureSwitch(key: key)
        }
    }
    
    private func touchAction() {
        guard let info = self.info,
              let action = info.action else { return }
        switch action {
        case .pushVC:
            guard let nextVCIndentifier = info.nextVCIdentifier else { return }
            self.delegate?.pushVC(nextVCIdentifier: nextVCIndentifier)
        case .goSafari:
            guard let url = info.url else { return }
            self.delegate?.goSafari(url: url)
        case .deeplink:
            guard let link = info.url else { return }
            self.delegate?.deeplink(link: link)
        }
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
}
