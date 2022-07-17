//
//  StandardDailyGraphView.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2022/07/16.
//  Copyright © 2022 FDEE. All rights reserved.
//

import UIKit
import SwiftUI

final class StandardDailyGraphView: UIView {
    /* public */
    var timelineFrameView: UIView = {
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
    /* private */
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
        return collectionView
    }()
    private var timesFrameView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.borderWidth = 2
        view.layer.borderColor = UIColor(named: "System_border")?.cgColor
        return view
    }()
    private var totalTimeView = TimeView(title: "Total")
    private var maxTimeView = TimeView(title: "Max")
    private var progressView = TasksCircularProgressView()
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
    
    private var tasks: [TaskInfo] = [] {
        didSet {
            self.tasksCollectionView.reloadData()
            self.layoutIfNeeded()
            self.progressView.updateProgress(tasks: tasks, width: .small)
        }
    }
    private let timelineVM = TimelineVM()
    
    convenience init() {
        self.init(frame: CGRect())
        self.commonInit()
        self.configureTimesView()
        self.configureCollectionView()
        self.configureProgressView()
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
    
    private func configureTimesView() {
        self.timesFrameView.addSubview(self.totalTimeView)
        NSLayoutConstraint.activate([
            self.totalTimeView.topAnchor.constraint(equalTo: self.timesFrameView.topAnchor, constant: 7),
            self.totalTimeView.centerXAnchor.constraint(equalTo: self.timesFrameView.centerXAnchor)
        ])
        
        self.timesFrameView.addSubview(self.maxTimeView)
        NSLayoutConstraint.activate([
            self.maxTimeView.topAnchor.constraint(equalTo: self.totalTimeView.bottomAnchor),
            self.maxTimeView.centerXAnchor.constraint(equalTo: self.timesFrameView.centerXAnchor)
        ])
    }
    
    private func configureCollectionView() {
        self.tasksCollectionView.delegate = self
        self.tasksCollectionView.dataSource = self
        let standardDailyTaskCellNib = UINib.init(nibName: StandardDailyTaskCell.identifier, bundle: nil)
        self.tasksCollectionView.register(standardDailyTaskCellNib.self, forCellWithReuseIdentifier: StandardDailyTaskCell.identifier)
    }
    
    private func configureProgressView() {
        self.timesFrameView.addSubview(self.progressView)
        NSLayoutConstraint.activate([
            self.progressView.topAnchor.constraint(equalTo: self.maxTimeView.bottomAnchor, constant: 18),
            self.progressView.centerXAnchor.constraint(equalTo: self.timesFrameView.centerXAnchor),
            self.progressView.widthAnchor.constraint(equalToConstant: 52),
            self.progressView.heightAnchor.constraint(equalToConstant: 52)
        ])
    }
    
    func configureTimelineLayout(_ view: UIView) {
        view.translatesAutoresizingMaskIntoConstraints = false
        self.timelineFrameView.addSubview(view)
        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: self.timelineFrameView.topAnchor, constant: 2),
            view.leadingAnchor.constraint(equalTo: self.timelineFrameView.leadingAnchor, constant: 2),
            view.trailingAnchor.constraint(equalTo: self.timelineFrameView.trailingAnchor, constant: -2),
            view.bottomAnchor.constraint(equalTo: self.timelineFrameView.bottomAnchor, constant: -2)
        ])
    }
}

extension StandardDailyGraphView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.tasks.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: StandardDailyTaskCell.identifier, for: indexPath) as? StandardDailyTaskCell else { return .init() }
        cell.configure(index: indexPath.item, taskInfo: self.tasks[indexPath.item])
        return cell
    }
}

extension StandardDailyGraphView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: StandardDailyTaskCell.height)
    }
}

// MARK: StandardDailyGraphView Public Actions
extension StandardDailyGraphView {
    /// dark, light mode 변경의 경우
    func updateDarkLightMode() {
        self.contentView.configureShadow()
        let borderColor = UIColor(named: "System_border")?.cgColor
        self.timelineFrameView.layer.borderColor = borderColor
        self.tasksCollectionView.layer.borderColor = borderColor
        self.timesFrameView.layer.borderColor = borderColor
    }
    /// daily 변경, 또는 color 변경의 경우
    func updateFromDaily(_ daily: Daily?) {
        self.updateDateLabel(daily?.day)
        self.updateDayOfWeek(daily?.day)
        self.totalTimeView.updateTime(to: daily?.totalTime)
        self.maxTimeView.updateTime(to: daily?.maxTime)
        self.timelineVM.update(daily: daily)
        
        self.updateTasks(with: daily?.tasks)
    }
}

// MARK: StandardDailyGraphView Private Actions
extension StandardDailyGraphView {
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
        self.daysOfWeekStackView.arrangedSubviews[targetIndex].backgroundColor = UIColor(named: String.userTintColor)?.withAlphaComponent(0.5)
    }
    
    private func updateTasks(with tasks: [String: Int]?) {
        guard let tasks = tasks else {
            self.tasks = []
            return
        }
        
        self.tasks = tasks.sorted(by: { $0.value > $1.value})
            .map { TaskInfo(taskName: $0.key, taskTime: $0.value) }
    }
}

// MARK: 요일표시용 CustomView
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

// MARK: TimesFrameView 내 표시용 CustomView
final class TimeView: UIView {
    private var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = TiTiFont.HGGGothicssiP60g(size: 12)
        label.textColor = UIColor.label
        label.textAlignment = .center
        NSLayoutConstraint.activate([
            label.heightAnchor.constraint(equalToConstant: 14)
        ])
        return label
    }()
    private var timeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = TiTiFont.HGGGothicssiP80g(size: 22)
        label.textColor = UIColor(named: String.userTintColor)
        label.textAlignment = .center
        NSLayoutConstraint.activate([
            label.heightAnchor.constraint(equalToConstant: 21)
        ])
        label.text = "0:00:00"
        return label
    }()
    
    convenience init(title: String) {
        self.init(frame: CGRect())
        self.commonInit(title)
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
