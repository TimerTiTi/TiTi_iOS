//
//  TasksCircularProgressView.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2022/07/17.
//  Copyright © 2022 FDEE. All rights reserved.
//

import UIKit

final class TasksCircularProgressView: UIView {
    private let blockValue = Float(0.003)
    private var progressValue: Float = 1
    enum ProgressWidth: CGFloat {
        case small = 25
        case medium = 35
    }
    
    convenience init() {
        self.init(frame: CGRect())
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func updateProgress(tasks: [TaskInfo], width: ProgressWidth, isReversColor: Bool) {
        self.resetProgress()
        let totalValue = Float(tasks.reduce(0, { $0 + $1.taskTime })) + self.blockValue*Float(tasks.count)
        let progressFrame = CGRect(x: 0, y: 0, width: self.bounds.width, height: self.bounds.height)
        self.progressValue = 1
        self.addBlock(progressFrame, width)
        
        let tasks = tasks.sorted(by: { $0.taskTime < $1.taskTime })
        for (idx, task) in tasks.enumerated() {
            let progress = StaticCircularProgressView(frame: progressFrame)
            progress.progressWidth = width.rawValue
            progress.trackColor = UIColor.clear
            progress.progressColor = self.progressColor(idx: idx, count: tasks.count, isReversColor: isReversColor)
            progress.setProgressWithAnimation(duration: 0.7, value: self.progressValue, from: 0)
            
            self.progressValue -= Float(task.taskTime)/totalValue
            self.addSubview(progress)
            
            self.addBlock(progressFrame, width)
        }
    }
    
    private func progressColor(idx: Int, count: Int, isReversColor: Bool) -> UIColor {
        let userColorIndex = UserDefaultsManager.get(forKey: .startColor) as? Int ?? 1
        var progressColorIndex = 0
        if isReversColor {
            progressColorIndex = (userColorIndex - (count-1) + idx + 12)%12
        } else {
            progressColorIndex = (userColorIndex + (count-1) - idx + 12)%12
        }
        return TiTiColor.graphColor(num: progressColorIndex == 0 ? 12 : progressColorIndex)
    }
    
    private func addBlock(_ frame: CGRect, _ width: ProgressWidth) {
        let block = StaticCircularProgressView(frame: frame)
        block.progressWidth = width.rawValue
        block.trackColor = UIColor.clear
        block.progressColor = UIColor.systemBackground
        block.setProgressWithAnimation(duration: 0.7, value: self.progressValue, from: 0)
        
        self.progressValue -= self.blockValue
        self.addSubview(block)
    }
    
    private func resetProgress() {
        self.subviews.forEach { $0.removeFromSuperview() }
    }
}
