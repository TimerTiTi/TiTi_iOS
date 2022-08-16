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
        finishButton.setTitle("ADD", for: .normal)
        finishButton.isEnabled = false
        editTaskButton.setImage(UIImage(systemName: "plus.circle"), for: .normal)
        taskLabel.text = "과목명을 입력해주세요"
    }
}
