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
        self.titleLabel.font = .systemFont(ofSize: 18, weight: .bold)
        self.titleLabel.text = self.alertTitle
        self.messageLabel.font = .systemFont(ofSize: 13, weight: .regular)
        self.textField.font = .systemFont(ofSize: 15, weight: .regular)
        self.textField.text = self.taskName
        self.textField.placeholder = Localized.string(.Tasks_Hint_NewTaskTitle)
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
        self.messageLabel.text = Localized.string(.EditDaily_Popup_SameTaskExist)
        self.messageLabel.textColor = .red
    }
    
    func showNormalMessage() {
        self.messageLabel.text = Localized.string(.EditDaily_Popup_EditTaskNameDesc)
        self.messageLabel.textColor = .label
    }
}
