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
        label.font = Fonts.HGGGothicssiP80g(size: 25)
        label.textColor = UIColor.label
        label.textAlignment = .left
        label.text = "0000.00"
        NSLayoutConstraint.activate([
            label.heightAnchor.constraint(equalToConstant: 27.5)
        ])
        return label
    }()
    private var weekNumLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Fonts.HGGGothicssiP80g(size: 25)
        label.textColor = UIColor.label
        label.textAlignment = .left
        label.text = "WEEK 5"
        NSLayoutConstraint.activate([
            label.heightAnchor.constraint(equalToConstant: 27.5)
        ])
        return label
    }()
    private var weekTermLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Fonts.HGGGothicssiP60g(size: 14)
        label.textColor = UIColor.label
        label.textAlignment = .left
        label.text = "00.00 ~ 00.00"
        return label
    }()
    private var timelineGraphFrameView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            view.widthAnchor.constraint(equalToConstant: 223),
            view.heightAnchor.constraint(equalToConstant: 130)
        ])
        return view
    }()
    private var timelineTimesFrameView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            view.heightAnchor.constraint(equalToConstant: 140),
            view.widthAnchor.constraint(equalToConstant: 97)
        ])
        return view
    }()
    private var totalTimeView = TimeView(title: "Total", size: .small)
    private var averageTimeView = TimeView(title: "Average", size: .small)
    private lazy var timelineStackView: UIView = {
        let stackView = UIStackView(arrangedSubviews: [self.timelineGraphFrameView, self.timelineTimesFrameView])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.layer.borderWidth = 2
        stackView.layer.borderColor = UIColor(named: "System_border")?.cgColor
        stackView.axis = .horizontal
        stackView.spacing = 0
        NSLayoutConstraint.activate([
            stackView.widthAnchor.constraint(equalToConstant: 325),
            stackView.heightAnchor.constraint(equalToConstant: 140)
        ])
        return stackView
    }()
    private lazy var tasksCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.itemSize = StandardWeekTaskCell.size
        layout.sectionInset = UIEdgeInsets(top: 2, left: 0, bottom: 0, right: 0)
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.layer.borderWidth = 2
        collectionView.layer.borderColor = UIColor(named: "System_border")?.cgColor
        NSLayoutConstraint.activate([
            collectionView.widthAnchor.constraint(equalToConstant: 223)
        ])
        collectionView.tag = 0
        collectionView.backgroundColor = TiTiColor.systemBackground
        return collectionView
    }()
    private var timesFrameView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.borderWidth = 2
        view.layer.borderColor = UIColor(named: "System_border")?.cgColor
        return view
    }()
    private var Top5TimeView = TimeView(title: "Top5", size: .small)
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
        self.configureTimesView()
        self.configureCollectionView()
    }
    
    private func commonInit() {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = TiTiColor.systemBackground
        NSLayoutConstraint.activate([
            self.widthAnchor.constraint(equalToConstant: 365),
            self.heightAnchor.constraint(equalToConstant: 365)
        ])
        
        self.contentView.addSubview(self.monthLabel)
        NSLayoutConstraint.activate([
            self.monthLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 10),
            self.monthLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 10)
        ])
        
        self.contentView.addSubview(self.weekNumLabel)
        NSLayoutConstraint.activate([
            self.weekNumLabel.bottomAnchor.constraint(equalTo: self.monthLabel.bottomAnchor),
            self.weekNumLabel.leadingAnchor.constraint(equalTo: self.monthLabel.trailingAnchor, constant: 12)
        ])
        
        self.contentView.addSubview(self.weekTermLabel)
        NSLayoutConstraint.activate([
            self.weekTermLabel.bottomAnchor.constraint(equalTo: self.monthLabel.bottomAnchor),
            self.weekTermLabel.leadingAnchor.constraint(equalTo: self.weekNumLabel.trailingAnchor, constant: 8)
        ])
        
        self.addSubview(self.contentView)
        NSLayoutConstraint.activate([
            self.contentView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            self.contentView.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
        
        self.contentView.addSubview(self.timelineStackView)
        NSLayoutConstraint.activate([
            self.timelineStackView.topAnchor.constraint(equalTo: self.weekTermLabel.bottomAnchor, constant: 8),
            self.timelineStackView.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor)
        ])
        
        self.contentView.addSubview(self.tasksCollectionView)
        NSLayoutConstraint.activate([
            self.tasksCollectionView.topAnchor.constraint(equalTo: self.timelineStackView.bottomAnchor, constant: 5),
            self.tasksCollectionView.leadingAnchor.constraint(equalTo: self.timelineStackView.leadingAnchor),
            self.tasksCollectionView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -12.5)
        ])
        
        self.contentView.addSubview(self.timesFrameView)
        NSLayoutConstraint.activate([
            self.timesFrameView.topAnchor.constraint(equalTo: self.tasksCollectionView.topAnchor),
            self.timesFrameView.leadingAnchor.constraint(equalTo: self.tasksCollectionView.trailingAnchor, constant: 5),
            self.timesFrameView.trailingAnchor.constraint(equalTo: self.timelineStackView.trailingAnchor),
            self.timesFrameView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -12.5)
        ])
        
        self.contentView.configureShadow()
    }
    
    private func configureTimesView() {
        self.timelineTimesFrameView.addSubview(self.totalTimeView)
        NSLayoutConstraint.activate([
            self.totalTimeView.topAnchor.constraint(equalTo: self.timelineTimesFrameView.topAnchor, constant: 48),
            self.totalTimeView.centerXAnchor.constraint(equalTo: self.timelineTimesFrameView.centerXAnchor)
        ])
        
        self.timelineTimesFrameView.addSubview(self.averageTimeView)
        NSLayoutConstraint.activate([
            self.averageTimeView.topAnchor.constraint(equalTo: self.totalTimeView.bottomAnchor, constant: 3),
            self.averageTimeView.centerXAnchor.constraint(equalTo: self.timelineTimesFrameView.centerXAnchor)
        ])
        
        self.timesFrameView.addSubview(self.Top5TimeView)
        NSLayoutConstraint.activate([
            self.Top5TimeView.topAnchor.constraint(equalTo: self.timesFrameView.topAnchor, constant: 10),
            self.Top5TimeView.centerXAnchor.constraint(equalTo: self.timesFrameView.centerXAnchor)
        ])
        
        self.timesFrameView.addSubview(self.progressView)
        NSLayoutConstraint.activate([
            self.progressView.topAnchor.constraint(equalTo: self.Top5TimeView.bottomAnchor, constant: 20),
            self.progressView.centerXAnchor.constraint(equalTo: self.timesFrameView.centerXAnchor),
            self.progressView.widthAnchor.constraint(equalToConstant: 52),
            self.progressView.heightAnchor.constraint(equalToConstant: 52)
        ])
    }
    
    private func configureCollectionView() {
        let standardWeekTaskCellNib = UINib.init(nibName: StandardWeekTaskCell.identifier, bundle: nil)
        self.tasksCollectionView.register(standardWeekTaskCellNib, forCellWithReuseIdentifier: StandardWeekTaskCell.identifier)
    }
}

// MARK: StandardWeekGraphView Public Configure Functions
extension StandardWeekGraphView {
    func configureDelegate(_ delegate: (UICollectionViewDataSource)) {
        self.tasksCollectionView.dataSource = delegate
    }
    
    func configureTimelineLayout(_ view: UIView) {
        view.translatesAutoresizingMaskIntoConstraints = false
        self.timelineGraphFrameView.addSubview(view)
        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: self.timelineGraphFrameView.topAnchor, constant: 2),
            view.leadingAnchor.constraint(equalTo: self.timelineGraphFrameView.leadingAnchor, constant: 2),
            view.trailingAnchor.constraint(equalTo: self.timelineGraphFrameView.trailingAnchor, constant: -2),
            view.bottomAnchor.constraint(equalTo: self.timelineGraphFrameView.bottomAnchor, constant: -2)
        ])
    }
}

// MARK: StandardWeekGraphView Public Actions
extension StandardWeekGraphView {
    func updateDarkLightMode() {
        /// dark, light mode 변경의 경우
        self.contentView.configureShadow()
        let borderColor = UIColor(named: "System_border")?.cgColor
        self.timelineStackView.layer.borderColor = borderColor
        self.tasksCollectionView.layer.borderColor = borderColor
        self.timesFrameView.layer.borderColor = borderColor
    }
    /// weekData 변경, 또는 color 변경의 경우
    func updateFromWeekData(_ weekData: WeekDailysData) {
        self.updateMonthLabel(weekData.weekDates.last)
        self.updateWeekNumLabel(weekData.weekNum)
        self.updateWeekTermLabel(weekData.weekDates.first, weekData.weekDates.last)
        self.totalTimeView.updateTime(to: weekData.totalTime)
        self.averageTimeView.updateTime(to: weekData.averageTime)
        self.Top5TimeView.updateTime(to: weekData.top5Time)
    }
    /// tasks 가 변경되어 collectionView 를 update 하는 경우
    func reload() {
        self.tasksCollectionView.reloadData()
    }
}

// MARK: StandardWeekGraphView Private Actions
extension StandardWeekGraphView {
    private func updateMonthLabel(_ day: Date?) {
        guard let day = day else {
            self.monthLabel.text = "0000.00"
            return
        }
        
        self.monthLabel.text = day.YYYYMMstypeString
    }
    
    private func updateWeekNumLabel(_ num: Int) {
        self.weekNumLabel.text = "WEEK \(num)"
    }
    
    private func updateWeekTermLabel(_ mon: Date?, _ sun: Date?) {
        guard let mon = mon, let sun = sun else {
            self.weekTermLabel.text = "00.00 ~ 00.00"
            return
        }
        
        self.weekTermLabel.text = "\(mon.MMDDstyleString) ~ \(sun.MMDDstyleString)"
    }
}
