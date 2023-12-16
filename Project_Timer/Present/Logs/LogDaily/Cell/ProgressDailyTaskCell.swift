//
//  ProgressDailyTaskCell.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2022/07/23.
//  Copyright © 2022 FDEE. All rights reserved.
//

import UIKit

final class ProgressDailyTaskCell: UICollectionViewCell {
    static let identifier = "ProgressDailyTaskCell"
    static let height = CGFloat(20)
    
    @IBOutlet var taskNameLabel: UILabel!
    @IBOutlet var taskTimeLabel: UILabel!
    @IBOutlet var tasksBackgroundView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.tasksBackgroundView.layer.cornerRadius = 2
    }
    
    func configure(index: Int, taskInfo: TaskInfo, isReversColor: Bool) {
        self.taskNameLabel.text = taskInfo.taskName
        self.taskTimeLabel.text = taskInfo.taskTime.toTimeString
        self.updateColor(index: index, isReversColor: isReversColor)
    }
    
    private func updateColor(index: Int, isReversColor: Bool) {
        let startColorIndex = UserDefaultsManager.get(forKey: .startColor) as? Int ?? 1
        var colorIndex = 0
        if isReversColor {
            colorIndex = (startColorIndex - index + 12)%12 == 0 ? 12 : (startColorIndex - index + 12)%12
        } else {
            colorIndex = (startColorIndex + index + 12)%12 == 0 ? 12 : (startColorIndex + index + 12)%12
        }
        let color = Colors.graphColor(num: colorIndex)
        self.tasksBackgroundView.backgroundColor = color
        self.taskTimeLabel.textColor = color
    }
}
