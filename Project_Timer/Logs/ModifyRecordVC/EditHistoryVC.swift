//
//  EditHistoryViewController.swift
//  Project_Timer
//
//  Created by 최수정 on 2022/08/15.
//  Copyright © 2022 FDEE. All rights reserved.
//

import UIKit
import Combine

/// TaskHistory 편집 창의 뷰컨트롤러
class EditHistoryVC: UIViewController {
    @IBOutlet weak var startTimeButton: UIButton!
    @IBOutlet weak var endTimeButton: UIButton!
    @IBOutlet weak var intervalLabel: UILabel!
    
    @Published var history: TaskHistory = TaskHistory(startDate: Date(), endDate: Date())
    private var cancellables = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.bind()
        self.configureColor()
    }
    
    @IBAction func startTimeButtonTapped(_ sender: UIButton) {
        self.popoverEditDateVC(on: sender,
                               date: self.history.startDate) { [weak self] newStartDate in
            self?.history.updateStartDate(to: newStartDate)
        }
    }
    
    @IBAction func endTimeButtonTapped(_ sender: UIButton) {
        self.popoverEditDateVC(on: sender,
                               date: self.history.endDate) { [weak self] newEndDate in
            self?.history.updateEndDate(to: newEndDate)
        }
    }
}

// MARK: 바인딩 & configure
extension EditHistoryVC {
    private func bind() {
        self.$history
            .receive(on: DispatchQueue.main)
            .sink { history in
                self.startTimeButton.setTitle(history.startDate.HHmmssStyleString, for: .normal)
                self.endTimeButton.setTitle(history.endDate.HHmmssStyleString, for: .normal)
                self.intervalLabel.text = history.interval.toHHmmss
            }
            .store(in: &self.cancellables)
    }
    
    private func configureColor() {
        let userTintColor = UIColor(named: String.userTintColor)
        self.startTimeButton.backgroundColor = userTintColor?.withAlphaComponent(0.5)
        self.startTimeButton.borderColor = userTintColor
        self.endTimeButton.backgroundColor = userTintColor?.withAlphaComponent(0.5)
        self.endTimeButton.borderColor = userTintColor
        self.intervalLabel.textColor = userTintColor
    }
}

// MARK: DatePicker 띄우기
extension EditHistoryVC: UIPopoverPresentationControllerDelegate {
    private func popoverEditDateVC(on sourceView: UIView, date: Date, changeHandler: @escaping DateChangeHandler) {
        guard let editDateVC = storyboard?.instantiateViewController(withIdentifier: "EditDateVC") as? EditDateVC else { return }
        
        editDateVC.modalPresentationStyle = .popover
        editDateVC.popoverPresentationController?.sourceView = sourceView
        editDateVC.popoverPresentationController?.delegate = self
        
        editDateVC.date = date
        editDateVC.changeHandler = changeHandler    // 변경된 Date값을 수행할 코드를 클로저로 전달
        
        present(editDateVC, animated: true)
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
}
