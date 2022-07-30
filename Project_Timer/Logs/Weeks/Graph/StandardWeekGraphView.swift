//
//  StandardWeekGraphView.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2022/07/30.
//  Copyright © 2022 FDEE. All rights reserved.
//

import UIKit

final class StandardWeekGraphView: UIView {
    /* public */
    let progressView = TasksCircularProgressView()
    /* private */
    private var monthLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = TiTiFont.HGGGothicssiP80g(size: 25)
        label.textColor = UIColor.label
        NSLayoutConstraint.activate([
            label.heightAnchor.constraint(equalToConstant: 27.5)
        ])
        label.textAlignment = .center
        label.text = "0000.00"
        return label
    }()
    private var contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(named: "Background_second")
        view.layer.cornerRadius = 25
        NSLayoutConstraint.activate([
            view.widthAnchor.constraint(equalToConstant: 345),
            view.heightAnchor.constraint(equalToConstant: 345)
        ])
        return view
    }()
    
    convenience init() {
        self.init(frame: CGRect())
        self.commonInit()
    }
    
    private func commonInit() {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = UIColor.systemBackground
        NSLayoutConstraint.activate([
            self.widthAnchor.constraint(equalToConstant: 365),
            self.heightAnchor.constraint(equalToConstant: 365)
        ])
        
        self.contentView.addSubview(self.monthLabel)
        NSLayoutConstraint.activate([
            self.monthLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 10),
            self.monthLabel.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor)
        ])
        
        self.addSubview(self.contentView)
        NSLayoutConstraint.activate([
            self.contentView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            self.contentView.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
        
        
        
        self.contentView.configureShadow()
    }
}

extension StandardWeekGraphView {
    func updateDarkLightMode() {
        self.contentView.configureShadow()
    }
    
    func updateFromWeekData(_ weekData: DailysWeekData) {
        self.updateMonthLabel(weekData.weekDates.first)
    }
}

extension StandardWeekGraphView {
    private func updateMonthLabel(_ day: Date?) {
        guard let day = day else {
            self.monthLabel.text = "0000.00"
            return
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY.MM"
        self.monthLabel.text = dateFormatter.string(from: day)
    }
}
