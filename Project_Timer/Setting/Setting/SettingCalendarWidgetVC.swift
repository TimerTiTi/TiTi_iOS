//
//  SettingCalendarWidgetVC.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2023/05/24.
//  Copyright © 2023 FDEE. All rights reserved.
//

import UIKit

final class SettingCalendarWidgetVC: UIViewController {
    private var descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        label.text = "Widget shows the top 5 tasks and the recording time by date.".localized()
        label.textColor = .lightGray
        label.numberOfLines = 0
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureUI()
    }
}

extension SettingCalendarWidgetVC {
    private func configureUI() {
        self.title = "Calendar widget".localized()
        self.view.backgroundColor = .systemGroupedBackground
        
        self.view.addSubview(self.descriptionLabel)
        NSLayoutConstraint.activate([
            self.descriptionLabel.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 0),
            self.descriptionLabel.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            self.descriptionLabel.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -16)
        ])
    }
}
