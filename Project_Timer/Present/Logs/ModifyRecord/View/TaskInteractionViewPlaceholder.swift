//
//  InteractionViewPlaceholder.swift
//  Project_Timer
//
//  Created by 최수정 on 2022/08/16.
//  Copyright © 2022 FDEE. All rights reserved.
//

import UIKit

final class TaskInteractionViewPlaceholder: UIView {
    private var messageLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = Localized.string(.EditDaily_Text_InfoHowToEditDaily)
        label.numberOfLines = 2
        label.textAlignment = .center
        label.font = Fonts.HGGGothicssiP60g(size: 17)
        label.textColor = UIColor.label
        return label
    }()
    
    convenience init() {
        self.init(frame: CGRect())
        
        self.addSubview(messageLabel)
        NSLayoutConstraint.activate([
            self.messageLabel.topAnchor.constraint(equalTo: self.topAnchor),
            self.messageLabel.rightAnchor.constraint(equalTo: self.rightAnchor),
            self.messageLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            self.messageLabel.leftAnchor.constraint(equalTo: self.leftAnchor)
        ])
    }
    
    func setText(mode: ModifyRecordVM.Mode) {
        switch mode {
        case .modify:
            self.messageLabel.text = Localized.string(.EditDaily_Text_InfoHowToEditDaily)
        case .create:
            self.messageLabel.text = Localized.string(.EditDaily_Text_InfoHowToCreateDaily)
        }
    }
}
