//
//  TaskCreateInteractionView.swift
//  Project_Timer
//
//  Created by 최수정 on 2022/08/16.
//  Copyright © 2022 FDEE. All rights reserved.
//

import UIKit

final class TaskCreateInteractionView: TaskInteractionView {
    // TaskInteractionView + ADD 비활성화 버튼 표시, plus 아이콘 표시
    // task = nil -> 과목명 입력 title 표시
    convenience init() {
        self.init(frame: CGRect())
        self.configureFinishButton(title: "ADD")
        self.disableFinishButton()
        self.configureEditTaskButton(image: UIImage(systemName: "plus.circle"))
    }
    
    override func update(colorIndex: Int, task: String?, historys: [TaskHistory]) {
        super.update(colorIndex: colorIndex, task: task, historys: historys)
        if task == nil {
            self.configureTaskLabel(task: "과목명을 입력해주세요")
        }
    }
}
