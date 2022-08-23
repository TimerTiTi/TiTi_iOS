//
//  EditTaskNameVC.swift
//  Project_Timer
//
//  Created by 최수정 on 2022/08/23.
//  Copyright © 2022 FDEE. All rights reserved.
//

import UIKit

class EditTaskNameVC: UIViewController {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var textField: UITextField!
    
    private var alertTitle: String?
    private var taskName: String?
    private var handler: ((String?)->Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.titleLabel.text = self.alertTitle
        self.textField.text = self.taskName
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.textField.becomeFirstResponder()
    }
    
    func showErrorMessage() {
        self.messageLabel.text = "동일한 과목명이 존재합니다"
        self.messageLabel.textColor = .red
    }
    
    func showNormalMessage() {
        self.messageLabel.text = "새로운 과목을 입력해주세요"
        self.messageLabel.textColor = .label
    }
    
    func configure(title: String?, taskName: String?, handler: ((String?)->Void)? = nil) {
        self.alertTitle = title
        self.taskName = taskName
        self.handler = handler
    }
    
    @IBAction func textFieldValueChanged(_ sender: UITextField) {
        self.handler?(sender.text)
    }
}
