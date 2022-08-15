//
//  EditDateVC.swift
//  Project_Timer
//
//  Created by 최수정 on 2022/08/15.
//  Copyright © 2022 FDEE. All rights reserved.
//

import UIKit

typealias DateChangeHandler = (Date) -> Void

class EditDateVC: UIViewController {
    var date: Date = Date()
    var changeHandler: DateChangeHandler?
    
    @IBOutlet weak var datePicker: UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.datePicker.date = date
    }
    
    @IBAction func dateValueChanged(_ sender: UIDatePicker) {
        guard let changeHandler = changeHandler else { return }
        changeHandler(sender.date)
    }
}
