//
//  TaskModifyInteractionView.swift
//  Project_Timer
//
//  Created by 최수정 on 2022/08/16.
//  Copyright © 2022 FDEE. All rights reserved.
//

import UIKit

final class TaskModifyInteractionView: TaskInteractionView {
    convenience init() {
        self.init(frame: CGRect())
        self.configureFinishButton(to: "OK")
        self.updateFinishButtonEnable(to: true)
        self.configureEditTaskButton(to: .edit)
    }
}
