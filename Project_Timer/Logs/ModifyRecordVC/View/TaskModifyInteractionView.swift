//
//  TaskModifyInteractionView.swift
//  Project_Timer
//
//  Created by 최수정 on 2022/08/16.
//  Copyright © 2022 FDEE. All rights reserved.
//

import UIKit

class TaskModifyInteractionView: TaskInteractionView {
    convenience init() {
        self.init(frame: CGRect())
        self.configureFinishButton(title: "OK")
        self.enableFinishButton()
        self.configureEditTaskButton(image: UIImage(systemName: "pencil.circle"))
    }
}
