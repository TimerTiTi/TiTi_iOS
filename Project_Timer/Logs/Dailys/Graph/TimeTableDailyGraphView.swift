//
//  TimeTableDailyGraphView.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2023/01/05.
//  Copyright © 2023 FDEE. All rights reserved.
//

import UIKit

final class TimeTableDailyGraphView: UIView {
    /* public */
    var timeTableFrameView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.borderWidth = 2
        view.layer.borderColor = UIColor(named: "System_border")?.cgColor
        NSLayoutConstraint.activate([
            view.widthAnchor.constraint(equalToConstant: 105)
        ])
        return view
    }()
    let progressView = TasksCircularProgressView()
    /* private */
    private var dateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = TiTiFont.HGGGothicssiP80g(size: 25)
        label.textColor = UIColor.label
        NSLayoutConstraint.activate([
            label.heightAnchor.constraint(equalToConstant: 27.5)
        ])
        label.textAlignment = .left
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
    private var timesLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Times"
        label.textColor = UIColor.label
        label.font = TiTiFont.HGGGothicssiP60g(size: 16)
        NSLayoutConstraint.activate([
            label.heightAnchor.constraint(equalToConstant: 18)
        ])
        return label
    }()
    private var timeTableLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "TimeTable"
        label.textColor = UIColor.label
        label.font = TiTiFont.HGGGothicssiP60g(size: 16)
        NSLayoutConstraint.activate([
            label.heightAnchor.constraint(equalToConstant: 18)
        ])
        return label
    }()
    private var timesFrameView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.borderWidth = 2
        view.layer.borderColor = UIColor(named: "System_border")?.cgColor
        NSLayoutConstraint.activate([
            view.widthAnchor.constraint(equalToConstant: 215),
            view.heightAnchor.constraint(equalToConstant: 100)
        ])
        return view
    }()
    private lazy var tasksCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.sectionInset = UIEdgeInsets(top: 2, left: 0, bottom: 0, right: 0)
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.layer.borderWidth = 2
        collectionView.layer.borderColor = UIColor(named: "System_border")?.cgColor
        NSLayoutConstraint.activate([
            collectionView.widthAnchor.constraint(equalToConstant: 215)
        ])
        collectionView.tag = 0
        collectionView.backgroundColor = UIColor(named: "Background_second")
        return collectionView
    }()
    
    private var totalTimeView = TimeView(title: "Total", size: .small)
    private var maxTimeView = TimeView(title: "Max", size: .small)
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
        self.backgroundColor = TiTiColor.systemBackground
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
            self.daysOfWeekStackView.addArrangedSubview(DayOfWeekLabel(day: day, size: .small))
        }
        self.contentView.addSubview(self.daysOfWeekStackView)
        NSLayoutConstraint.activate([
            self.daysOfWeekStackView.centerYAnchor.constraint(equalTo: self.dateLabel.centerYAnchor, constant: 4),
            self.daysOfWeekStackView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -12.5)
        ])
        
        self.contentView.addSubview(self.timesLabel)
        NSLayoutConstraint.activate([
            self.timesLabel.topAnchor.constraint(equalTo: self.daysOfWeekStackView.bottomAnchor, constant: 5)
        ])

        self.contentView.addSubview(self.timesFrameView)
        NSLayoutConstraint.activate([
            self.timesFrameView.topAnchor.constraint(equalTo: self.timesLabel.bottomAnchor),
            self.timesFrameView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            self.timesLabel.centerXAnchor.constraint(equalTo: self.timesFrameView.centerXAnchor)
        ])
        
        self.contentView.addSubview(self.timeTableLabel)
        NSLayoutConstraint.activate([
            self.timeTableLabel.topAnchor.constraint(equalTo: self.daysOfWeekStackView.bottomAnchor, constant: 5)
        ])

        self.contentView.addSubview(self.timeTableFrameView)
        NSLayoutConstraint.activate([
            self.timeTableFrameView.topAnchor.constraint(equalTo: self.timeTableLabel.bottomAnchor),
            self.timeTableFrameView.leadingAnchor.constraint(equalTo: self.timesFrameView.trailingAnchor, constant: 5),
            self.timeTableFrameView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -12.5),
            self.timeTableLabel.centerXAnchor.constraint(equalTo: self.timeTableFrameView.centerXAnchor)
        ])

        self.contentView.addSubview(self.tasksCollectionView)
        NSLayoutConstraint.activate([
            self.tasksCollectionView.topAnchor.constraint(equalTo: self.timesFrameView.bottomAnchor, constant: 5),
            self.tasksCollectionView.leadingAnchor.constraint(equalTo: self.timesFrameView.leadingAnchor),
            self.tasksCollectionView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -12.5)
        ])
        
        self.contentView.configureShadow()
    }
}

extension TimeTableDailyGraphView {
    func updateDarkLightMode() {
        self.contentView.configureShadow()
        let borderColor = UIColor(named: "System_border")?.cgColor
        self.timesFrameView.layer.borderColor = borderColor
        self.timeTableFrameView.layer.borderColor = borderColor
        self.tasksCollectionView.layer.borderColor = borderColor
    }
}
