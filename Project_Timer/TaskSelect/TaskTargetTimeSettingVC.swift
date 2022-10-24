//
//  TaskTargetTimeSettingVC.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2022/10/24.
//  Copyright © 2022 FDEE. All rights reserved.
//

import UIKit

protocol TaskTargetTimeUpdateable: AnyObject {
    func updateTargetTime(index: Int, to: Int)
}

final class TaskTargetTimeSettingVC: UIViewController {
    static let identifier = "TaskTargetTimeSettingVC"
    
    @IBOutlet weak var taskNameLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    @IBOutlet weak var hourButton: UIButton!
    @IBOutlet weak var minuteButton: UIButton!
    @IBOutlet weak var secondButton: UIButton!
    
    private var task: Task!
    private var index: Int!
    private var settedTargetTime: Int!
    private weak var delegate: TaskTargetTimeUpdateable?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureLocalized()
        self.updateTargetTime()
    }
    
    func configure(task: Task, index: Int, delegate: TaskTargetTimeUpdateable) {
        self.task = task
        self.index = index
        self.settedTargetTime = task.taskTargetTime
        self.delegate = delegate
    }
    
    
    @IBAction func showMenus(_ sender: UIButton) {
        let targetButton: UIButton
        switch sender.tag {
        case 0: targetButton = self.hourButton
        case 1: targetButton = self.minuteButton
        case 2: targetButton = self.secondButton
        default: return
        }
    }
}

extension TaskTargetTimeSettingVC {
    private func configureLocalized() {
        self.taskNameLabel.text = task.taskName
        self.subTitleLabel.text = "Setting Target Time".localized()
    }
    
    private func updateTargetTime() {
        let h = self.settedTargetTime/3600
        let s = self.settedTargetTime%60
        let m = self.settedTargetTime/60 - 60*h
        
        self.setButtonTitle(button: self.hourButton, time: h, "H")
        self.setButtonTitle(button: self.minuteButton, time: m, "M")
        self.setButtonTitle(button: self.secondButton, time: s, "S")
    }
    
    private func setButtonTitle(button: UIButton, time: Int, _ placeHolder: String) {
        if time != 0 {
            button.setTitle("\(time)", for: .normal)
            button.setTitleColor(.label, for: .normal)
        } else {
            button.setTitle(placeHolder, for: .normal)
            button.setTitleColor(.tertiaryLabel, for: .normal)
        }
    }
}

// MARK: PickerView
extension TaskTargetTimeSettingVC: UIPopoverPresentationControllerDelegate {
    func popoverVC(on sourceView: UIView, key: UserDefaultsManager.Keys, handler: @escaping TargetTimeHandelr) {
        guard let pickerVC = storyboard?.instantiateViewController(withIdentifier: TargetTimePickerPopupVC.identifier) as? TargetTimePickerPopupVC else { return }
        
        pickerVC.modalPresentationStyle = .popover
        pickerVC.popoverPresentationController?.sourceView = sourceView
        pickerVC.popoverPresentationController?.delegate = self
        let viewModel = TargetTimePickerVM(key: key)
        pickerVC.configure(viewModel: viewModel, handler: handler)
        
        present(pickerVC, animated: true)
    }
    /// iPhone 에서 popover 형식으로 띄우기 위한 로직
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
}
