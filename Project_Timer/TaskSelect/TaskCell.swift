//
//  TaskCell.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2022/10/23.
//  Copyright © 2022 FDEE. All rights reserved.
//

import UIKit

final class TaskCell: UITableViewCell {
    static let identifier = "TaskCell"
    static let height: CGFloat = 54
    
    @IBOutlet weak var taskNameLabel: UILabel!
    @IBOutlet weak var taskTargetTimesStackView: UIStackView!
    @IBOutlet weak var taskTargetTimeLabel: UILabel!
    @IBOutlet weak var taskTargetTime: UILabel!
    @IBOutlet weak var editTaskTargetTimeButton: UIButton!
    @IBOutlet weak var taskTargetTimeSwitch: UISwitch!
    
    @IBOutlet weak var taskNameLabelTopConst: NSLayoutConstraint!
    var toggleTargetTime: ((Bool) -> Void)?
    var editTargetTime: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.taskTargetTimeSwitch.isOn = false
        self.taskTargetTimesStackView.alpha = 0
    }
    
    @IBAction func toggleTargetTime(_ sender: UISwitch) {
        UIView.animate(withDuration: 0.3) {
            self.taskNameLabelTopConst.constant = sender.isOn ? 8 : 15
            self.taskTargetTimesStackView.alpha = sender.isOn ? 1 : 0
            self.editTaskTargetTimeButton.alpha = sender.isOn ? 1 : 0
            self.layoutIfNeeded()
        }
        self.toggleTargetTime?(sender.isOn)
    }
    
    @IBAction func editTargetTime(_ sender: Any) {
        self.editTargetTime?()
    }
    
    func configure(task: Task, color: UIColor?) {
        self.configureColor(color: color)
        self.taskNameLabel.text = task.taskName
        self.taskTargetTimeSwitch.isOn = task.isTaskTargetTimeOn
        self.taskTargetTimeLabel.text = "Setted Target Time:".localized()
        self.taskTargetTime.text = task.taskTargetTime.toTimeString
        self.taskNameLabelTopConst.constant = task.isTaskTargetTimeOn ? 8 : 15
        self.taskTargetTimesStackView.alpha = task.isTaskTargetTimeOn ? 1 : 0
        self.editTaskTargetTimeButton.alpha = task.isTaskTargetTimeOn ? 1 : 0
    }
}

extension TaskCell {
    private func configureColor(color: UIColor?) {
        self.editTaskTargetTimeButton.tintColor = color
        self.taskTargetTimeSwitch.onTintColor = color
        self.taskTargetTimeSwitch.tintColor = color
    }
}
