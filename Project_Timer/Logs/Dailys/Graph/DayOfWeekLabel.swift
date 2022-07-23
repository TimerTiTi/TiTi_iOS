//
//  DayOfWeekLabel.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2022/07/23.
//  Copyright © 2022 FDEE. All rights reserved.
//

import UIKit

// MARK: 요일표시용 CustomView
final class DayOfWeekLabel: UILabel {
    enum Size {
        case large
        case small
    }
    
    convenience init(day: String, size: Size) {
        self.init(frame: CGRect())
        self.translatesAutoresizingMaskIntoConstraints = false
        self.font = TiTiFont.HGGGothicssiP60g(size: 13)
        self.textColor = UIColor.label
        self.textAlignment = .center
        
        let width: CGFloat = (size == .small) ? 25 : 38
        let height: CGFloat = (size == .small) ? 15 : 20
        NSLayoutConstraint.activate([
            self.widthAnchor.constraint(equalToConstant: width),
            self.heightAnchor.constraint(equalToConstant: height)
        ])
        self.text = day
    }
}
