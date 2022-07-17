//
//  StandardDailyTaskCell.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2022/07/17.
//  Copyright © 2022 FDEE. All rights reserved.
//

import UIKit

final class StandardDailyTaskCell: UICollectionViewCell {
    static let identifier = "StandardDailyTaskCell"
    static let height: CGFloat = CGFloat(20)
    
    @IBOutlet var checkIcon: UILabel!
    @IBOutlet var taskNameLabel: UILabel!
    @IBOutlet var taskTimeLabel: UILabel!
    @IBOutlet var taskBackgroundView: UIView!
    
    func configure(index: Int, taskInfo: TaskInfo) {
        self.taskNameLabel.text = taskInfo.taskName
        self.taskTimeLabel.text = taskInfo.taskTime.toTimeString
        self.updateColor(index: index)
    }
    
    private func updateColor(index: Int) {
        let startColorIndex = UserDefaultsManager.get(forKey: .startColor) as? Int ?? 1
        let colorIndex = (startColorIndex+index)%12 == 0 ? 12 : (startColorIndex+index)%12
        let color = UIColor.graphColor(num: colorIndex)
        self.checkIcon.textColor = color
        self.taskBackgroundView.backgroundColor = color
        self.taskTimeLabel.textColor = color
    }
}
