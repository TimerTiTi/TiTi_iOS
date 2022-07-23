//
//  TasksProgressDailyGraphView.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2022/07/16.
//  Copyright © 2022 FDEE. All rights reserved.
//

import UIKit

final class TasksProgressDailyGraphView: UIView {
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
//            self.tasksCollectionView.reloadData()
            self.layoutIfNeeded()
            self.progressView.updateProgress(tasks: tasks, width: .medium)
        }
    }
    
    convenience init() {
        self.init(frame: CGRect())
        self.commonInit()
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
            self.dateLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 15),
            self.dateLabel.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor)
        ])
        
        self.contentView.configureShadow()
    }
    
    private func configureProgressView() {
        self.contentView.addSubview(self.progressView)
        NSLayoutConstraint.activate([
            self.progressView.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor),
            self.progressView.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor, constant: 20),
            self.progressView.widthAnchor.constraint(equalToConstant: 250),
            self.progressView.heightAnchor.constraint(equalToConstant: 250)
        ])
    }
}

// MARK: TasksProgressDailyGraphView Public Actions
extension TasksProgressDailyGraphView {
    /// dark, light mode 변경의 경우
    func updateDarkLightMode() {
        self.contentView.configureShadow()
    }
    /// daily 변경, 또는 color 변경의 경우
    func updateFromDaily(_ daily: Daily?) {
        self.updateDateLabel(daily?.day)
        self.updateTasks(with: daily?.tasks)
    }
}

// MARK: TasksProgressDailyGraphView Private Actions
extension TasksProgressDailyGraphView {
    private func updateDateLabel(_ day: Date?) {
        guard let day = day else {
            self.dateLabel.text = "0000.00.00"
            return
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY.MM.dd"
        self.dateLabel.text = dateFormatter.string(from: day)
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
