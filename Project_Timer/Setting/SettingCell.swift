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
        return toggle
    }()
    
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
    
    func configure(with info: SettingCellInfo) {
        self.titleLabel.text = info.title
        self.subTitleLabel.text = info.subTitle != nil ? info.subTitle : ""
        self.rightLabel.text = info.rightTitle != nil ? info.rightTitle : ""
        self.touchableMark.isHidden = !info.touchable
        
        if info.switchable {
            self.configureSwitchColor()
            self.configureSwitch()
        }
    }
    
    private func configureSwitchColor() {
        let colorIndex = UserDefaults.standard.value(forKey: "startColor") as? Int ?? 1
        let color = UIColor(named: "D\(colorIndex)")
        self.toggleSwitch.tintColor = color
        self.toggleSwitch.onTintColor = color
    }
    
    private func configureSwitch() {
        self.toggleSwitch.isHidden = false
    }
}
