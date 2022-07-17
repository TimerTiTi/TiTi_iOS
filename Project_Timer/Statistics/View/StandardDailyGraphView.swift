//
//  StandardDailyGraphView.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2022/07/16.
//  Copyright © 2022 FDEE. All rights reserved.
//

import UIKit

final class StandardDailyGraphView: UIView {
    private var dateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = TiTiFont.HGGGothicssiP80g(size: 25)
        label.textColor = UIColor.label
        NSLayoutConstraint.activate([
            label.heightAnchor.constraint(equalToConstant: 27.5)
        ])
        label.text = "0000.00.00"
        return label
    }()
    private var daysOfWeekStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 5
        return stackView
    }()
    private var timeLineLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "TimeLine"
        label.textColor = UIColor.label
        label.font = TiTiFont.HGGGothicssiP60g(size: 16)
        NSLayoutConstraint.activate([
            label.heightAnchor.constraint(equalToConstant: 18)
        ])
        return label
    }()
    private var timelineFrameView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.borderWidth = 2
        view.layer.borderColor = UIColor(named: "System_border")?.cgColor
        NSLayoutConstraint.activate([
            view.widthAnchor.constraint(equalToConstant: 325),
            view.heightAnchor.constraint(equalToConstant: 100)
        ])
        return view
    }()
    private var tasksCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: CGRect(), collectionViewLayout: .init())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.layer.borderWidth = 2
        collectionView.layer.borderColor = UIColor(named: "System_border")?.cgColor
        NSLayoutConstraint.activate([
            collectionView.widthAnchor.constraint(equalToConstant: 215)
        ])
        return collectionView
    }()
    private var timesFrameView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.borderWidth = 2
        view.layer.borderColor = UIColor(named: "System_border")?.cgColor
        return view
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
        
        self.addSubview(self.contentView)
        NSLayoutConstraint.activate([
            self.contentView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            self.contentView.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
        
        self.contentView.addSubview(self.dateLabel)
        NSLayoutConstraint.activate([
            self.dateLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 10),
            self.dateLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 10)
        ])
        
        ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"].forEach { day in
            self.daysOfWeekStackView.addArrangedSubview(DayOfWeekLabel(day: day))
        }
        self.contentView.addSubview(self.daysOfWeekStackView)
        NSLayoutConstraint.activate([
            self.daysOfWeekStackView.centerYAnchor.constraint(equalTo: self.dateLabel.centerYAnchor, constant: 4),
            self.daysOfWeekStackView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -12.5)
        ])
        
        self.contentView.addSubview(self.timeLineLabel)
        NSLayoutConstraint.activate([
            self.timeLineLabel.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor),
            self.timeLineLabel.topAnchor.constraint(equalTo: self.daysOfWeekStackView.bottomAnchor, constant: 5)
        ])
        
        self.contentView.addSubview(self.timelineFrameView)
        NSLayoutConstraint.activate([
            self.timelineFrameView.topAnchor.constraint(equalTo: self.timeLineLabel.bottomAnchor),
            self.timelineFrameView.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor)
        ])
        
        self.contentView.addSubview(self.tasksCollectionView)
        NSLayoutConstraint.activate([
            self.tasksCollectionView.topAnchor.constraint(equalTo: self.timelineFrameView.bottomAnchor, constant: 5),
            self.tasksCollectionView.leadingAnchor.constraint(equalTo: self.timelineFrameView.leadingAnchor),
            self.tasksCollectionView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -12.5)
        ])
        
        self.contentView.addSubview(self.timesFrameView)
        NSLayoutConstraint.activate([
            self.timesFrameView.topAnchor.constraint(equalTo: self.tasksCollectionView.topAnchor),
            self.timesFrameView.leadingAnchor.constraint(equalTo: self.tasksCollectionView.trailingAnchor, constant: 5),
            self.timesFrameView.trailingAnchor.constraint(equalTo: self.timelineFrameView.trailingAnchor),
            self.timesFrameView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -12.5)
        ])
        
        self.contentView.configureShadow()
    }
    
    func updateDarkLightMode() {
        self.contentView.configureShadow()
        let borderColor = UIColor(named: "System_border")?.cgColor
        self.timelineFrameView.layer.borderColor = borderColor
        self.tasksCollectionView.layer.borderColor = borderColor
        self.timesFrameView.layer.borderColor = borderColor
    }
    
    func updateFromDaily(_ daily: Daily?) {
        self.updateDateLabel(daily?.day)
        self.updateDayOfWeek(daily?.day)
    }
    
    private func updateDateLabel(_ day: Date?) {
        guard let day = day else {
            self.dateLabel.text = "0000.00.00"
            return
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY.MM.dd"
        self.dateLabel.text = dateFormatter.string(from: day)
    }
    
    private func updateDayOfWeek(_ day: Date?) {
        self.daysOfWeekStackView.arrangedSubviews.forEach { $0.backgroundColor = UIColor.clear }
        guard let day = day else { return }
        let targetIndex = day.indexDayOfWeek
        print(targetIndex)
        self.daysOfWeekStackView.arrangedSubviews[targetIndex].backgroundColor = UIColor(named: String.userTintColor)?.withAlphaComponent(0.5)
    }
}

final class DayOfWeekLabel: UILabel {
    convenience init(day: String) {
        self.init(frame: CGRect())
        self.translatesAutoresizingMaskIntoConstraints = false
        self.font = TiTiFont.HGGGothicssiP60g(size: 13)
        self.textColor = UIColor.label
        self.textAlignment = .center
        
        NSLayoutConstraint.activate([
            self.widthAnchor.constraint(equalToConstant: 25),
            self.heightAnchor.constraint(equalToConstant: 15)
        ])
        self.text = day
    }
}
