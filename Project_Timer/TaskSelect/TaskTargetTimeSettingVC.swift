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
    private var hour: Int!
    private var minute: Int!
    private var second: Int!
    private weak var delegate: TaskTargetTimeUpdateable?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureLocalized()
        self.configureTask()
        self.updateTargetTime()
    }
    
    func configure(task: Task, index: Int, delegate: TaskTargetTimeUpdateable) {
        self.task = task
        self.index = index
        self.delegate = delegate
    }
    
    @IBAction func showMenus(_ sender: UIButton) {
        switch sender.tag {
        case 0:
            self.popoverVC(on: self.hourButton, type: .hour) { [weak self] hour in
                self?.hour = hour
                self?.updateSettedTargetTime()
            }
        case 1:
            self.popoverVC(on: self.minuteButton, type: .minute) { [weak self] minute in
                self?.minute = minute
                self?.updateSettedTargetTime()
            }
        case 2:
            self.popoverVC(on: self.secondButton, type: .second) { [weak self] second in
                self?.second = second
                self?.updateSettedTargetTime()
            }
        default: return
        }
    }
}

extension TaskTargetTimeSettingVC {
    private func configureLocalized() {
        self.subTitleLabel.text = "Setting Target Time".localized()
    }
    
    private func configureTask() {
        self.taskNameLabel.text = task.taskName
        self.settedTargetTime = task.taskTargetTime
        self.hour = settedTargetTime/3600
        self.second = settedTargetTime%60
        self.minute = settedTargetTime/60 - 60*hour
    }
    
    private func updateSettedTargetTime() {
        self.settedTargetTime = self.hour*3600 + self.minute*60 + self.second
        self.updateTargetTime()
        self.delegate?.updateTargetTime(index: self.index, to: self.settedTargetTime)
    }
    
    private func updateTargetTime() {
        self.setButtonTitle(button: self.hourButton, time: hour, "H")
        self.setButtonTitle(button: self.minuteButton, time: minute, "M")
        self.setButtonTitle(button: self.secondButton, time: second, "S")
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
    func popoverVC(on sourceView: UIView, type: TimeSelectorPopupVC.type, handler: @escaping SelectTimeHandler) {
        guard let pickerVC = storyboard?.instantiateViewController(withIdentifier: TimeSelectorPopupVC.identifier) as? TimeSelectorPopupVC else { return }
        
        pickerVC.modalPresentationStyle = .popover
        pickerVC.popoverPresentationController?.sourceView = sourceView
        pickerVC.popoverPresentationController?.delegate = self
        pickerVC.configure(type: type, handler: handler)
        
        present(pickerVC, animated: true)
    }
    /// iPhone 에서 popover 형식으로 띄우기 위한 로직
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
}
