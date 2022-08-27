//
//  TaskModifyInteractionView.swift
//  Project_Timer
//
//  Created by 최수정 on 2022/08/16.
//  Copyright © 2022 FDEE. All rights reserved.
//

import UIKit

final class TaskModifyInteractionView: TaskInteractionView {
    // TaskInteractionView + OK 활성화 버튼 표시, edit 아이콘 표시
    convenience init() {
        self.init(frame: CGRect())
        self.configureFinishButton(title: "OK")
        self.enableFinishButton()
        self.configureEditTaskButton(image: UIImage(systemName: "pencil.circle"))
    }
}
