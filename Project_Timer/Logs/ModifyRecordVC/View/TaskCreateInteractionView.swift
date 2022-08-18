//
//  TaskCreateInteractionView.swift
//  Project_Timer
//
//  Created by 최수정 on 2022/08/16.
//  Copyright © 2022 FDEE. All rights reserved.
//

import UIKit

class TaskCreateInteractionView: TaskInteractionView {
    convenience init() {
        self.init(frame: CGRect())
        self.configureFinishButton(title: "ADD")
        self.disableFinishButton()
        self.configureEditTaskButton(image: UIImage(systemName: "plus.circle"))
    }
    
    override func update(task: String?, historys: [TaskHistory]?) {
        super.update(task: task, historys: historys)
        if task == nil {
            self.configureTaskLabel(task: "과목명을 입력해주세요")
        }
    }
}
