//
//  TasksProgressDailyGraphView.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2022/07/16.
//  Copyright © 2022 FDEE. All rights reserved.
//

import UIKit

final class TasksProgressDailyGraphView: UIView {
    /* public */
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
        label.textAlignment = .center
        label.text = "0000.00.00"
        return label
    }()
    private var collectionViewHeightContstraint: NSLayoutConstraint?
    private lazy var tasksCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.widthAnchor.constraint(equalToConstant: 190),
        ])
        self.collectionViewHeightContstraint = collectionView.heightAnchor.constraint(equalToConstant: 160)
        self.collectionViewHeightContstraint?.isActive = true
        collectionView.tag = 1
        collectionView.backgroundView?.backgroundColor = UIColor(named: "Background_second")
        return collectionView
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
        self.configureCollectionView()
        self.configureProgressView()
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
            self.dateLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 15),
            self.dateLabel.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor)
        ])
        
        self.contentView.addSubview(self.tasksCollectionView)
        NSLayoutConstraint.activate([
            self.tasksCollectionView.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor),
            self.tasksCollectionView.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor, constant: 20)
        ])
        
        self.contentView.configureShadow()
    }
    
    private func configureCollectionView() {
        let progressDailyTaskCellNib = UINib.init(nibName: ProgressDailyTaskCell.identifier, bundle: nil)
        self.tasksCollectionView.register(progressDailyTaskCellNib, forCellWithReuseIdentifier: ProgressDailyTaskCell.identifier)
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

// MARK: TasksProgressDailyGraphView Public Configure Functions
extension TasksProgressDailyGraphView {
    func configureDelegate(_ delegate: (UICollectionViewDelegate&UICollectionViewDataSource)) {
        self.tasksCollectionView.delegate = delegate
        self.tasksCollectionView.dataSource = delegate
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
        self.collectionViewHeightContstraint?.constant = CGFloat(min(8, daily?.tasks.count ?? 0))*ProgressDailyTaskCell.height
    }
    /// tasks 가 변경되어 collectionView 를 update 하는 경우
    func reload() {
        self.tasksCollectionView.reloadData()
    }
}

// MARK: TasksProgressDailyGraphView Private Actions
extension TasksProgressDailyGraphView {
    private func updateDateLabel(_ day: Date?) {
        guard let day = day else {
            self.dateLabel.text = "0000.00.00"
            return
        }
        
        self.dateLabel.text = day.YYYYMMDDstyleString
    }
}
