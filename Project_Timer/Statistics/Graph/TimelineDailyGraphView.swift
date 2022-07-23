//
//  TimelineDailyGraphView.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2022/07/16.
//  Copyright © 2022 FDEE. All rights reserved.
//

import UIKit

final class TimelineDailyGraphView: UIView {
    /* public */
    var timelineFrameView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            view.widthAnchor.constraint(equalToConstant: 325),
            view.heightAnchor.constraint(equalToConstant: 150)
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
        label.textAlignment = .center
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
        label.font = TiTiFont.HGGGothicssiP60g(size: 20)
        NSLayoutConstraint.activate([
            label.heightAnchor.constraint(equalToConstant: 22)
        ])
        return label
    }()
    private var totalTimeView = TimeView(title: "Total", size: .large)
    private var maxTimeView = TimeView(title: "Max", size: .large)
    private lazy var timesStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [self.totalTimeView, self.maxTimeView])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 30
        stackView.alignment = .center
        return stackView
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
            self.dateLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 15),
            self.dateLabel.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor)
        ])
        
        ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"].forEach { day in
            self.daysOfWeekStackView.addArrangedSubview(DayOfWeekLabel(day: day, size: .large))
        }
        self.contentView.addSubview(self.daysOfWeekStackView)
        NSLayoutConstraint.activate([
            self.daysOfWeekStackView.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor),
            self.daysOfWeekStackView.topAnchor.constraint(equalTo: self.dateLabel.bottomAnchor, constant: 5)
        ])
        
        self.contentView.addSubview(self.timeLineLabel)
        NSLayoutConstraint.activate([
            self.timeLineLabel.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor),
            self.timeLineLabel.topAnchor.constraint(equalTo: self.daysOfWeekStackView.bottomAnchor, constant: 15)
        ])
        
        self.contentView.addSubview(self.timelineFrameView)
        NSLayoutConstraint.activate([
            self.timelineFrameView.topAnchor.constraint(equalTo: self.timeLineLabel.bottomAnchor),
            self.timelineFrameView.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor)
        ])
        
        self.contentView.addSubview(self.timesStackView)
        NSLayoutConstraint.activate([
            self.timesStackView.topAnchor.constraint(equalTo: self.timelineFrameView.bottomAnchor, constant: 14),
            self.timesStackView.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor)
        ])
        
        self.contentView.configureShadow()
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

// MARK: TimelineDailyGraphView Public Actions
extension TimelineDailyGraphView {
    /// dark, light mode 변경의 경우
    func updateDarkLightMode() {
        self.contentView.configureShadow()
    }
    /// daily 변경, 또는 color 변경이 경우
    func updateFromDaily(_ daily: Daily?) {
        self.updateDateLabel(daily?.day)
        self.updateDayOfWeek(daily?.day)
        self.totalTimeView.updateTime(to: daily?.totalTime)
        self.maxTimeView.updateTime(to: daily?.maxTime)
    }
}

// MARK: TimelineDailyGraphView Private Actions
extension TimelineDailyGraphView {
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
}
