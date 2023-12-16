//
//  TargetTimeButton.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2023/05/21.
//  Copyright © 2023 FDEE. All rights reserved.
//

import UIKit

final class TargetTimeButton: UIButton {
    private(set) var key: UserDefaultsManager.Keys = .goalTimeOfMonth
    private(set) var settedHour: Int = 0
    private var hourLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Fonts.HGGGothicssiP60g(size: 14)
        label.textColor = .label
        label.textAlignment = .right
        return label
    }()
    
    convenience init(key: UserDefaultsManager.Keys) {
        self.init(frame: CGRect())
        self.key = key
        self.configure(key: key)
    }
    
    private func configure(key: UserDefaultsManager.Keys) {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.layer.cornerRadius = 8
        self.layer.cornerCurve = .continuous
        self.backgroundColor = .systemGroupedBackground
        self.titleLabel?.font = Fonts.HGGGothicssiP60g(size: 17)
        self.setTitleColor(.label, for: .normal)
        self.contentHorizontalAlignment = .left
        self.titleEdgeInsets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 0)
        
        NSLayoutConstraint.activate([
            self.heightAnchor.constraint(equalToConstant: 45)
        ])
        
        switch key {
        case .goalTimeOfMonth:
            self.setTitle("Month", for: .normal)
        case .goalTimeOfWeek:
            self.setTitle("Week", for: .normal)
        case .calendarWidgetTargetTime:
            self.setTitle("Daily", for: .normal)
        default:
            return
        }
        
        self.addSubview(self.hourLabel)
        NSLayoutConstraint.activate([
            self.hourLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            self.hourLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16)
        ])
        
        self.updateTime()
    }
    
    func updateTime() {
        switch self.key {
        case .goalTimeOfMonth:
            self.settedHour = UserDefaultsManager.get(forKey: .goalTimeOfMonth) as? Int ?? 100*3600
        case .goalTimeOfWeek:
            self.settedHour = UserDefaultsManager.get(forKey: .goalTimeOfWeek) as? Int ?? 30*3600
        case .calendarWidgetTargetTime:
            self.settedHour = UserDefaultsManager.get(forKey: .calendarWidgetTargetTime) as? Int ?? 6*3600
        default:
            return
        }
        
        self.hourLabel.text = "\(self.settedHour/3600) H"
    }
}
