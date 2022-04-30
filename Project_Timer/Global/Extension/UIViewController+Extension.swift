//
//  UIViewController+Extension.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2022/04/30.
//  Copyright © 2022 FDEE. All rights reserved.
//

import UIKit

extension UIViewController {
    func showAlertWithOK(title: String, text: String) {
        let alert = UIAlertController(title: title, message: text, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default)
        alert.addAction(ok)
        present(alert, animated: true)
    }
    
    func showTaskWarningAlert() {
        self.showAlertWithOK(title: "Enter a new subject".localized(), text: "")
    }
}
