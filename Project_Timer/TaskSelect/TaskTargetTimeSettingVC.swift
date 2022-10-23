//
//  TaskTargetTimeSettingVC.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2022/10/24.
//  Copyright © 2022 FDEE. All rights reserved.
//

import UIKit

final class TaskTargetTimeSettingVC: UIViewController {
    static let identifier = "TaskTargetTimeSettingVC"
    
    @IBOutlet weak var taskNameLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    
    @IBOutlet weak var hourTextField: UITextField!
    @IBOutlet weak var minuteTextField: UITextField!
    @IBOutlet weak var secondTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
