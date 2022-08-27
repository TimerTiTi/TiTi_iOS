//
//  EditHistoryViewController.swift
//  Project_Timer
//
//  Created by 최수정 on 2022/08/15.
//  Copyright © 2022 FDEE. All rights reserved.
//

import UIKit
import Combine

protocol DateValidator: AnyObject {
    func isValidDate(selected: Date) -> Bool
}

/// TaskHistory 편집 창의 뷰컨트롤러
final class PopupEditHistoryVC: UIViewController {
    static let identifier = "PopupEditHistoryVC"
    private weak var delegate: DateValidator?
    @IBOutlet weak var startTimeButton: UIButton!
    @IBOutlet weak var endTimeButton: UIButton!
    @IBOutlet weak var intervalLabel: UILabel!
    
    @Published var history: TaskHistory = TaskHistory(startDate: Date(), endDate: Date())
    private var didEditEndDate: Bool = false
    private var colorIndex: Int = 0
    private var cancellables = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.bind()
        self.configureColor()
    }
    
    @IBAction func startTimeButtonTapped(_ sender: UIButton) {
        self.popoverEditDateVC(on: sender, date: self.history.startDate) { [weak self] newStartDate in
            guard let self = self,
                  self.delegate?.isValidDate(selected: newStartDate) == true else { return }
            
            self.history.updateStartDate(to: newStartDate)
            // endDate를 수정한 적이 없는 경우 startDate와 동일하게 자동 맞춤
            if self.didEditEndDate == false {
                self.history.updateEndDate(to: newStartDate)
            }
        }
    }
    
    @IBAction func endTimeButtonTapped(_ sender: UIButton) {
        self.popoverEditDateVC(on: sender, date: self.history.endDate) { [weak self] newEndDate in
            guard let self = self,
                  self.delegate?.isValidDate(selected: newEndDate) == true else { return }
            
            self.history.updateEndDate(to: newEndDate)
            self.didEditEndDate = true
        }
    }
}

// MARK: 바인딩 & configure
extension PopupEditHistoryVC {
    func configure(delegate: DateValidator, history: TaskHistory, isNewHistory: Bool, colorIndex: Int) {
        self.delegate = delegate
        self.history = history
        self.didEditEndDate = !isNewHistory
        self.colorIndex = colorIndex
    }
    
    private func configureColor() {
        let color = TiTiColor.graphColor(num: self.colorIndex)
        self.startTimeButton.backgroundColor = color.withAlphaComponent(0.5)
        self.startTimeButton.borderColor = color
        self.endTimeButton.backgroundColor = color.withAlphaComponent(0.5)
        self.endTimeButton.borderColor = color
        self.intervalLabel.textColor = color
    }
    
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
}

// MARK: DatePicker 띄우기
extension PopupEditHistoryVC: UIPopoverPresentationControllerDelegate {
    func popoverEditDateVC(on sourceView: UIView, date: Date, handler: @escaping DateChangeHandler) {
        guard let editDateVC = storyboard?.instantiateViewController(withIdentifier: PopupSelectDateVC.identifier) as? PopupSelectDateVC else { return }
        
        editDateVC.modalPresentationStyle = .popover
        editDateVC.popoverPresentationController?.sourceView = sourceView
        editDateVC.popoverPresentationController?.delegate = self
        editDateVC.configure(date: date, dateChangeHandler: handler) // 변경된 Date값으로 수행할 코드를 클로저로 전달
        
        present(editDateVC, animated: true)
    }
    /// iPhone 에서 popover 형식으로 띄우기 위한 로직
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
}
