//
//  TaskModifyInteractionView.swift
//  Project_Timer
//
//  Created by 최수정 on 2022/08/14.
//  Copyright © 2022 FDEE. All rights reserved.
//

import UIKit

typealias TaskInteractionViewDelegate = EditTaskButtonDelegate & FinishButtonDelegate & UITableViewDelegate & UITableViewDataSource

protocol EditTaskButtonDelegate: AnyObject {
    func editTaskButtonTapped()
}

protocol FinishButtonDelegate: AnyObject {
    func finishButtonTapped()
}

class TaskInteractionView: UIView {
    /* public */
    var finishButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            button.heightAnchor.constraint(equalToConstant: 30),
            button.widthAnchor.constraint(equalToConstant: 70)
        ])
        button.backgroundColor = UIColor(named: String.userTintColor)
        button.cornerRadius = 6
        button.setTitle("OK", for: .normal)
        button.setTitleColor(UIColor.label, for: .normal)
        button.titleLabel?.font = TiTiFont.HGGGothicssiP60g(size: 18)
        return button
    }()
    var editTaskButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            button.heightAnchor.constraint(equalToConstant: 35),
            button.widthAnchor.constraint(equalTo: button.heightAnchor)
        ])
        button.tintColor = UIColor.label
        button.setImage(UIImage(systemName: "pencil.circle"), for: .normal)
        return button
    }()
    var historyTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.contentInset = UIEdgeInsets(top: -5, left: 0, bottom: 0, right: 0)
        tableView.separatorColor = UIColor.clear    // 안됨
        // TODO: separator 없애기
        return tableView
    }()
    
    /* private */
    private static let createCategoryLabel: (String) -> UILabel = { title in
        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = title
        titleLabel.font = TiTiFont.HGGGothicssiP60g(size: 16)
        titleLabel.textColor = UIColor.label
        return titleLabel
    }
    private var taskCategoryLabel: UILabel = TaskInteractionView.createCategoryLabel("Task:")
    private var timeCategoryLabel: UILabel = TaskInteractionView.createCategoryLabel("Time:")
    private var historysCategoryLabel: UILabel = TaskInteractionView.createCategoryLabel("Historys:")
    private var taskLabel: PaddingLabel = {
        let label = PaddingLabel(vertical: 0, horizontal: 7)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = TiTiFont.HGGGothicssiP60g(size: 16)
        label.textColor = UIColor.label
        NSLayoutConstraint.activate([
            label.heightAnchor.constraint(equalToConstant: 25)
        ])
        label.textAlignment = .center
        label.backgroundColor = UIColor(named: String.userTintColor)?.withAlphaComponent(0.5)
        label.text = "알고리즘"
        label.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        label.clipsToBounds = true
        label.layer.cornerRadius = 6
        return label
    }()
    private var totalTimeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = TiTiFont.HGGGothicssiP80g(size: 19)
        label.textColor = UIColor(named: String.userTintColor)
        label.textAlignment = .center
        label.text = "00:00:00"
        return label
    }()
    private weak var delegate: (EditTaskButtonDelegate & FinishButtonDelegate)? {
        didSet {
            self.editTaskButton.addAction(UIAction(handler: { [weak self] _ in
                self?.delegate?.editTaskButtonTapped()
            }), for: .touchUpInside)
            self.finishButton.addAction(UIAction(handler: { [weak self] _ in
                self?.delegate?.finishButtonTapped()
            }), for: .touchUpInside)
        }
    }
    
    convenience init() {
        self.init(frame: CGRect())
        self.commonInit()
        self.configureTableView()
    }
    
    private func commonInit() {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = UIColor.systemBackground
        self.cornerRadius = 25
        NSLayoutConstraint.activate([
            self.widthAnchor.constraint(equalToConstant: 345)
        ])
        
        // taskCategoryLabel
        self.addSubview(self.taskCategoryLabel)
        NSLayoutConstraint.activate([
            taskCategoryLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 14),
            taskCategoryLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 17)
        ])
        
        // timeCategoryLabel
        self.addSubview(self.timeCategoryLabel)
        NSLayoutConstraint.activate([
            timeCategoryLabel.leadingAnchor.constraint(equalTo: self.taskCategoryLabel.leadingAnchor),
            timeCategoryLabel.topAnchor.constraint(equalTo: taskCategoryLabel.bottomAnchor, constant: 17)
        ])
        
        // historysCategoryLabel
        self.addSubview(self.historysCategoryLabel)
        NSLayoutConstraint.activate([
            historysCategoryLabel.leadingAnchor.constraint(equalTo: self.taskCategoryLabel.leadingAnchor),
            historysCategoryLabel.topAnchor.constraint(equalTo: timeCategoryLabel.bottomAnchor, constant: 17)
        ])
        
        // editTaskButton
        self.addSubview(self.editTaskButton)
        NSLayoutConstraint.activate([
            self.editTaskButton.centerYAnchor.constraint(equalTo: self.taskCategoryLabel.centerYAnchor),
            self.editTaskButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -14)
        ])
        
        // finishButton
        self.addSubview(self.finishButton)
        NSLayoutConstraint.activate([
            self.finishButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -17),
            self.finishButton.centerXAnchor.constraint(equalTo: self.centerXAnchor)
        ])
        
        // historyTableView
        self.addSubview(self.historyTableView)
        NSLayoutConstraint.activate([
            self.historyTableView.leadingAnchor.constraint(equalTo: self.historysCategoryLabel.trailingAnchor, constant: 10),
            self.historyTableView.topAnchor.constraint(equalTo: self.historysCategoryLabel.topAnchor, constant: -3),
            self.historyTableView.trailingAnchor.constraint(equalTo: self.editTaskButton.trailingAnchor),
            self.historyTableView.bottomAnchor.constraint(equalTo: self.finishButton.topAnchor, constant: -17)
        ])
        
        // taskLabel
        self.addSubview(self.taskLabel)
        NSLayoutConstraint.activate([
            self.taskLabel.centerYAnchor.constraint(equalTo: self.taskCategoryLabel.centerYAnchor),
            self.taskLabel.leadingAnchor.constraint(equalTo: self.historyTableView.leadingAnchor),
            self.taskLabel.trailingAnchor.constraint(lessThanOrEqualTo: self.editTaskButton.leadingAnchor, constant: -8)
        ])
        
        // totalTimeLabel
        self.addSubview(self.totalTimeLabel)
        NSLayoutConstraint.activate([
            self.totalTimeLabel.centerYAnchor.constraint(equalTo: self.timeCategoryLabel.centerYAnchor),
            self.totalTimeLabel.leadingAnchor.constraint(equalTo: taskLabel.leadingAnchor)
        ])
    }
}

extension TaskInteractionView {
    func configureDelegate(_ delegate: TaskInteractionViewDelegate) {
        self.historyTableView.delegate = delegate
        self.historyTableView.dataSource = delegate
        self.delegate = delegate
    }
    
    func configureTableView() {
        let historyCellNib = UINib.init(nibName: HistoryCell.identifier, bundle: nil)
        let addHistoryCellNib = UINib.init(nibName: AddHistoryCell.identifier, bundle: nil)
        self.historyTableView.register(historyCellNib, forCellReuseIdentifier: HistoryCell.identifier)
        self.historyTableView.register(addHistoryCellNib, forCellReuseIdentifier: AddHistoryCell.identifier)
    }
}

extension TaskInteractionView {
    func update(task: String?, historys: [TaskHistory]?) {
        self.updateTaskLabel(task)
        self.updateTotalTimeLabel(historys?.reduce(0){ $0 + $1.interval } ?? 0)
        self.updateHistoryTableView()
    }
}

extension TaskInteractionView {
    private func updateTaskLabel(_ task: String?) {
        self.taskLabel.text = task
    }
    
    private func updateTotalTimeLabel(_ totalTime: Int) {
        self.totalTimeLabel.text = totalTime.toTimeString
    }
    
    private func updateHistoryTableView() {
        self.historyTableView.reloadData()
    }
}
