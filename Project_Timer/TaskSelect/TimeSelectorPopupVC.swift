//
//  TimeSelectorPopupVC.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2022/10/24.
//  Copyright © 2022 FDEE. All rights reserved.
//

import UIKit

typealias SelectTimeHandler = (Int) -> Void

final class TimeSelectorPopupVC: UIViewController {
    static let identifier = "TimeSelectorPopupVC"
    enum type {
        case hour
        case minute
        case second
    }
    
    @IBOutlet weak var picker: UIPickerView!
    private var numbers: [String] = []
    private var selectedHandler: SelectTimeHandler?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configurePicker()
    }
    
    func configure(type: type, handler: @escaping SelectTimeHandler) {
        self.selectedHandler = handler
        switch type {
        case .hour:
            self.numbers = (0...23).map{ "\($0)" }
        case .minute, .second:
            self.numbers = (0...59).map{ "\($0)" }
        }
    }
}

extension TimeSelectorPopupVC  {
    private func configurePicker() {
        self.picker.delegate = self
        self.picker.dataSource = self
    }
}

extension TimeSelectorPopupVC: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        guard let selectedNum = Int(self.numbers[row]) else { return }
        self.selectedHandler?(selectedNum)
    }
}

extension TimeSelectorPopupVC: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.numbers.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.numbers[safe: row] ?? ""
    }
}
