//
//  TimeView.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2022/07/23.
//  Copyright © 2022 FDEE. All rights reserved.
//

import UIKit

// MARK: TimesFrameView 내 표시용 CustomView
final class TimeView: UIView {
    enum Size {
        case large
        case small
    }
    private var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.label
        label.textAlignment = .center
        return label
    }()
    private var timeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor(named: String.userTintColor)
        label.textAlignment = .center
        label.text = "0:00:00"
        return label
    }()
    
    convenience init(title: String, size: Size) {
        self.init(frame: CGRect())
        self.configureTitleLabelSize(size)
        self.configureTimeLabelSize(size)
        if size == .large {
            NSLayoutConstraint.activate([
                self.widthAnchor.constraint(equalToConstant: 120)
            ])
        }
        self.commonInit(title)
    }
    
    private func configureTitleLabelSize(_ size: Size) {
        switch size {
        case .small:
            self.titleLabel.font = Fonts.HGGGothicssiP60g(size: 12)
            self.titleLabel.heightAnchor.constraint(equalToConstant: 14).isActive = true
        case .large:
            self.titleLabel.font = Fonts.HGGGothicssiP60g(size: 20)
            self.titleLabel.heightAnchor.constraint(equalToConstant: 22).isActive = true
        }
    }
    
    private func configureTimeLabelSize(_ size: Size) {
        switch size {
        case .small:
            self.timeLabel.font = Fonts.HGGGothicssiP80g(size: 22)
            self.timeLabel.heightAnchor.constraint(equalToConstant: 21).isActive = true
        case .large:
            self.timeLabel.font = Fonts.HGGGothicssiP80g(size: 35)
            self.timeLabel.heightAnchor.constraint(equalToConstant: 38.5).isActive = true
        }
    }
    
    private func commonInit(_ title: String) {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.titleLabel.text = title
        
        self.addSubview(self.titleLabel)
        NSLayoutConstraint.activate([
            self.titleLabel.topAnchor.constraint(equalTo: self.topAnchor),
            self.titleLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor)
        ])
        
        self.addSubview(self.timeLabel)
        NSLayoutConstraint.activate([
            self.timeLabel.topAnchor.constraint(equalTo: self.titleLabel.bottomAnchor),
            self.timeLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.timeLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.timeLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
}

// MARK: TimeView Public Actions
extension TimeView {
    func updateTime(to time: Int?) {
        self.timeLabel.textColor = UIColor(named: String.userTintColor)
        guard let time = time else {
            self.timeLabel.text = "0:00:00"
            return
        }
        
        self.timeLabel.text = time.toTimeString
    }
}
