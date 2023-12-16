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
    static let height = CGFloat(20)
    
    @IBOutlet var checkIcon: UILabel!
    @IBOutlet var taskNameLabel: UILabel!
    @IBOutlet var taskTimeLabel: UILabel!
    @IBOutlet var taskBackgroundView: UIView!
    
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
        self.checkIcon.textColor = color
        self.taskBackgroundView.backgroundColor = color
        self.taskTimeLabel.textColor = color
    }
    
    func highlightBorder() {
        self.layer.borderWidth = 2
        self.layer.borderColor = UIColor.red.cgColor
    }
    
    func removeHighlight() {
        self.layer.borderWidth = 0
    }
}
