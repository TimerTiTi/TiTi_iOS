//
//  TaskModifyInteractionView.swift
//  Project_Timer
//
//  Created by 최수정 on 2022/08/14.
//  Copyright © 2022 FDEE. All rights reserved.
//

import UIKit

class TaskInteractionView: UIView {
    /* public */
    var finishButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            button.heightAnchor.constraint(equalToConstant: 25),
            button.widthAnchor.constraint(equalToConstant: 70)
        ])
        button.backgroundColor = TiTiColor.blue
        button.titleLabel?.textColor = UIColor.label
        return button
    }()
    var editTaskButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            button.heightAnchor.constraint(equalToConstant: 27),
            button.widthAnchor.constraint(equalTo: button.heightAnchor)
        ])
        return button
    }()
    var historyTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
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
    private var taskLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = TiTiFont.HGGGothicssiP60g(size: 16)
        label.textColor = UIColor.label
        NSLayoutConstraint.activate([
            label.heightAnchor.constraint(equalToConstant: 25)
        ])
        label.textAlignment = .center
        label.backgroundColor = TiTiColor.blue?.withAlphaComponent(0.5)
        return label
    }()
    private var totalTimeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = TiTiFont.HGGGothicssiP60g(size: 16)
        label.textColor = TiTiColor.blue
        label.textAlignment = .center
        return label
    }()
    
    convenience init() {
        self.init(frame: CGRect())
        self.commonInit()
    }
    
    private func commonInit() {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = UIColor.systemBackground
        NSLayoutConstraint.activate([
            self.widthAnchor.constraint(equalToConstant: 365)
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
        
        // taskLabel
        self.addSubview(self.taskLabel)
        NSLayoutConstraint.activate([
            self.taskLabel.centerYAnchor.constraint(equalTo: self.taskCategoryLabel.centerYAnchor),
            self.taskLabel.leadingAnchor.constraint(equalTo: self.historyTableView.leadingAnchor)
        ])
        
        // editTaskButton
        self.addSubview(self.editTaskButton)
        NSLayoutConstraint.activate([
            self.editTaskButton.centerYAnchor.constraint(equalTo: self.taskLabel.centerYAnchor),
            self.editTaskButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -14)
        ])
        
        // totalTimeLabel
        self.addSubview(self.totalTimeLabel)
        NSLayoutConstraint.activate([
            self.totalTimeLabel.centerYAnchor.constraint(equalTo: self.timeCategoryLabel.centerYAnchor),
            self.totalTimeLabel.leadingAnchor.constraint(equalTo: taskLabel.leadingAnchor)
        ])
        
        // historyTableView
        self.addSubview(self.historyTableView)
        NSLayoutConstraint.activate([
            self.historyTableView.leadingAnchor.constraint(equalTo: self.historysCategoryLabel.trailingAnchor, constant: 10),
            self.historyTableView.topAnchor.constraint(equalTo: self.historysCategoryLabel.topAnchor),
            self.historyTableView.trailingAnchor.constraint(equalTo: self.editTaskButton.trailingAnchor),
            self.historyTableView.bottomAnchor.constraint(equalTo: self.finishButton.topAnchor, constant: 8)
        ])
        
        // okbutton
        self.addSubview(self.finishButton)
        NSLayoutConstraint.activate([
            self.finishButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -17),
            self.finishButton.centerXAnchor.constraint(equalTo: self.centerXAnchor)
        ])
    }
}
