//
//  EditDateVC.swift
//  Project_Timer
//
//  Created by 최수정 on 2022/08/15.
//  Copyright © 2022 FDEE. All rights reserved.
//

import UIKit

typealias DateChangeHandler = (Date) -> Void

/// DatePicker의 뷰컨트롤러
class EditDateVC: UIViewController {
    var date: Date = Date()
    var dateChangeHandler: DateChangeHandler?
    
    @IBOutlet weak var datePicker: UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.datePicker.date = date
    }
    
    @IBAction func dateValueChanged(_ sender: UIDatePicker) {
        // Presenting ViewController로부터 전달받은 핸들러 실행
        guard let date = sender.date.truncateSeconds else { return }
        self.dateChangeHandler?(date)
    }
    
    func configure(date: Date, dateChangeHandler: @escaping DateChangeHandler) {
        self.date = date
        self.dateChangeHandler = dateChangeHandler
    }
}
