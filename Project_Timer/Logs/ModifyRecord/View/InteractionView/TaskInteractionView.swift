//
//  TaskInteractionView.swift
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
    enum Icon: String {
        case plus = "plus.circle"
        case edit = "pencil.circle"
    }
    private weak var delegate: (EditTaskButtonDelegate & FinishButtonDelegate)?
    private var taskNameTitleLabel = InteractionLeftTitleLabel(title: "Task:")
    private var totalTimeTitleLabel = InteractionLeftTitleLabel(title: "Time:")
    private var historysTitleLabel = InteractionLeftTitleLabel(title: "Historys:")
    private var taskNameLabel: PaddingLabel = {
        let label = PaddingLabel(vertical: 0, horizontal: 7)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Fonts.HGGGothicssiP60g(size: 16)
        label.textColor = UIColor.label
        NSLayoutConstraint.activate([
            label.heightAnchor.constraint(equalToConstant: 25)
        ])
        label.textAlignment = .center
        label.backgroundColor = UIColor(named: String.userTintColor)?.withAlphaComponent(0.5)
        label.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        label.clipsToBounds = true
        label.layer.cornerRadius = 6
        return label
    }()
    private var editTaskNameButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            button.heightAnchor.constraint(equalToConstant: 35),
            button.widthAnchor.constraint(equalTo: button.heightAnchor)
        ])
        button.tintColor = UIColor.label
        return button
    }()
    private var totalTimeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Fonts.HGGGothicssiP80g(size: 19)
        label.textColor = UIColor(named: String.userTintColor)
        label.textAlignment = .center
        label.text = "00:00:00"
        return label
    }()
    private var taskHistorysTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.contentInset = UIEdgeInsets(top: -5, left: 0, bottom: 0, right: 0)
        tableView.separatorColor = UIColor.clear    // 안됨
        // TODO: separator 없애기
        return tableView
    }()
    private var finishButton = ModifyFinishButton()
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
        self.configureLayout()
        self.configureTableView()
    }
    
    convenience init() {
        self.init(frame: CGRect())
    }
    
    private func commonInit() {
        self.backgroundColor = UIColor.systemBackground
        self.layer.cornerRadius = 25
    }
    
    private func configureLayout() {
        self.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.widthAnchor.constraint(equalToConstant: 345)
        ])
        
        // taskName
        self.addSubview(self.taskNameTitleLabel)
        NSLayoutConstraint.activate([
            self.taskNameTitleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 17),
            self.taskNameTitleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 14)
        ])
        
        self.addSubview(self.taskNameLabel)
        NSLayoutConstraint.activate([
            self.taskNameLabel.centerYAnchor.constraint(equalTo: self.taskNameTitleLabel.centerYAnchor),
            self.taskNameLabel.leadingAnchor.constraint(equalTo: self.taskNameTitleLabel.trailingAnchor, constant: 10)
        ])
        
        self.addSubview(self.editTaskNameButton)
        NSLayoutConstraint.activate([
            self.editTaskNameButton.centerYAnchor.constraint(equalTo: self.taskNameTitleLabel.centerYAnchor),
            self.editTaskNameButton.leadingAnchor.constraint(greaterThanOrEqualTo: self.taskNameLabel.trailingAnchor, constant: 8),
            self.editTaskNameButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -9.5)
        ])
        // totalTime
        self.addSubview(self.totalTimeTitleLabel)
        NSLayoutConstraint.activate([
            self.totalTimeTitleLabel.topAnchor.constraint(equalTo: self.taskNameTitleLabel.bottomAnchor, constant: 17),
            self.totalTimeTitleLabel.leadingAnchor.constraint(equalTo: self.taskNameTitleLabel.leadingAnchor)
        ])
        
        self.addSubview(self.totalTimeLabel)
        NSLayoutConstraint.activate([
            self.totalTimeLabel.centerYAnchor.constraint(equalTo: self.totalTimeTitleLabel.centerYAnchor),
            self.totalTimeLabel.leadingAnchor.constraint(equalTo: self.taskNameLabel.leadingAnchor)
        ])
        // historys
        self.addSubview(self.historysTitleLabel)
        NSLayoutConstraint.activate([
            self.historysTitleLabel.topAnchor.constraint(equalTo: self.totalTimeTitleLabel.bottomAnchor, constant: 17),
            self.historysTitleLabel.leadingAnchor.constraint(equalTo: self.taskNameTitleLabel.leadingAnchor)
        ])
        
        self.addSubview(self.taskHistorysTableView)
        NSLayoutConstraint.activate([
            self.taskHistorysTableView.topAnchor.constraint(equalTo: self.historysTitleLabel.topAnchor, constant: -3),
            self.taskHistorysTableView.leadingAnchor.constraint(equalTo: self.taskNameLabel.leadingAnchor),
            self.taskHistorysTableView.trailingAnchor.constraint(equalTo: self.editTaskNameButton.trailingAnchor)
        ])
        // finish button
        self.addSubview(self.finishButton)
        NSLayoutConstraint.activate([
            self.finishButton.topAnchor.constraint(equalTo: self.taskHistorysTableView.bottomAnchor, constant: 17),
            self.finishButton.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            self.finishButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -13.5)
        ])
    }
    
    private func configureTableView() {
        let historyCellNib = UINib.init(nibName: HistoryCell.identifier, bundle: nil)
        let addHistoryCellNib = UINib.init(nibName: AddHistoryCell.identifier, bundle: nil)
        self.taskHistorysTableView.register(historyCellNib, forCellReuseIdentifier: HistoryCell.identifier)
        self.taskHistorysTableView.register(addHistoryCellNib, forCellReuseIdentifier: AddHistoryCell.identifier)
    }
}

// MARK: Public Configure Functions
extension TaskInteractionView {
    func configureDelegate(_ delegate: TaskInteractionViewDelegate) {
        self.delegate = delegate
        self.taskHistorysTableView.delegate = delegate
        self.taskHistorysTableView.dataSource = delegate
        
        self.editTaskNameButton.addAction(UIAction(handler: { [weak self] _ in
            self?.delegate?.editTaskButtonTapped()
        }), for: .touchUpInside)
        self.finishButton.addAction(UIAction(handler: { [weak self] _ in
            self?.delegate?.finishButtonTapped()
        }), for: .touchUpInside)
    }
    
    func configureFinishButton(to title: String) {
        self.finishButton.setTitle(title, for: .normal)
    }
    
    func configureEditTaskButton(to icon: Icon) {
        self.editTaskNameButton.setImage(UIImage(systemName: icon.rawValue), for: .normal)
    }
}

// MARK: Public functions
extension TaskInteractionView {
    func update(colorIndex: Int, task: String, historys: [TaskHistory]) {
        self.updateTaskName(to: task)
        self.updateTotalTime(to: historys.reduce(0){ $0 + $1.interval })
        self.configureColor(colorIndex: colorIndex)
    }
    
    func reload(withDelay: Bool = false) {
        if withDelay {
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .milliseconds(400)) { [weak self] in
                self?.taskHistorysTableView.reloadData()
            }
        } else {
            self.taskHistorysTableView.reloadData()
        }
    }
    
    func updateFinishButtonEnable(to enable: Bool) {
        self.finishButton.isEnabled = enable
    }
    
    func deleteRows(at: IndexPath) {
        self.taskHistorysTableView.deleteRows(at: [at], with: .automatic)
    }
}

extension TaskInteractionView {
    private func updateTaskName(to taskName: String) {
        self.taskNameLabel.text = taskName
    }
    
    private func updateTotalTime(to totalTime: Int) {
        self.totalTimeLabel.text = totalTime.toTimeString
    }
    
    private func configureColor(colorIndex: Int) {
        let color = TiTiColor.graphColor(num: colorIndex)
        self.taskNameLabel.backgroundColor = color.withAlphaComponent(0.5)
        self.totalTimeLabel.textColor = color
        self.finishButton.backgroundColor = color
    }
}
