//
//  TargetTimePickerPopupVC.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2022/10/07.
//  Copyright © 2022 FDEE. All rights reserved.
//

import UIKit

typealias TargetTimeHandelr = () -> Void

final class TargetTimePickerPopupVC: UIViewController {
    static let identifier = "TargetTimePickerPopupVC"
    @IBOutlet weak var picker: UIPickerView!
    
    private var viewModel: TargetTimePickerVM?
    private var selectedHandler: TargetTimeHandelr?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configurePicker()
    }
    
    func configure(viewModel: TargetTimePickerVM, handler: @escaping TargetTimeHandelr) {
        self.viewModel = viewModel
        self.selectedHandler = handler
    }
}

extension TargetTimePickerPopupVC {
    private func configurePicker() {
        self.picker.delegate = self
        self.picker.dataSource = self
    }
}

extension TargetTimePickerPopupVC: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.viewModel?.updateValue(index: row)
        self.selectedHandler?()
    }
}

extension TargetTimePickerPopupVC: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.viewModel?.items.count ?? 0
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.viewModel?.items[safe: row] ?? ""
    }
}
