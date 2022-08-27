//
//  PopupEditTaskNameVC.swift
//  Project_Timer
//
//  Created by 최수정 on 2022/08/23.
//  Copyright © 2022 FDEE. All rights reserved.
//

import UIKit

final class PopupEditTaskNameVC: UIViewController {
    static let identifier = "PopupEditTaskNameVC"
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var textField: UITextField!
    
    private var alertTitle: String?
    private var taskName: String?
    private var handler: ((String?) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.titleLabel.text = self.alertTitle
        self.textField.text = self.taskName
        self.showNormalMessage()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.textField.becomeFirstResponder()
    }
    
    @IBAction func textFieldValueChanged(_ sender: UITextField) {
        self.handler?(sender.text)
    }
    
    func configure(title: String?, taskName: String?, handler: ((String?) -> Void)? = nil) {
        self.alertTitle = title
        self.taskName = taskName
        self.handler = handler
    }
    
    func showErrorMessage() {
        self.messageLabel.text = "The same task name already exists.".localized()
        self.messageLabel.textColor = .red
    }
    
    func showNormalMessage() {
        self.messageLabel.text = "Please enter a new task.".localized()
        self.messageLabel.textColor = .label
    }
}
