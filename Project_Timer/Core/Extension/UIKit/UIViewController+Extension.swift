//
//  UIViewController+Extension.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2022/04/30.
//  Copyright © 2022 FDEE. All rights reserved.
//

import UIKit

extension UIViewController {
    // MARK: Gesture
    func addDismissingKeyboard() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self,
            action: #selector(UIViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    // MARK: Alert
    func showAlertWithOK(title: String, text: String) {
        let alert = UIAlertController(title: title, message: text, preferredStyle: .alert)
        let ok = UIAlertAction(title: Localized.string(.Common_Text_OK), style: .default)
        alert.addAction(ok)
        self.present(alert, animated: true)
    }
    
    func showAlertWithOKAfterHandler(title: String, text: String, completion: @escaping(() -> Void)) {
        let alert = UIAlertController(title: title, message: text, preferredStyle: .alert)
        let ok = UIAlertAction(title: Localized.string(.Common_Text_OK), style: .default) { _ in
            completion()
        }
        alert.addAction(ok)
        self.present(alert, animated: true)
    }
    
    func showAlertWithCancelOKAfterHandler(title: String, text: String?, completion: @escaping(() -> Void)) {
        let alert = UIAlertController(title: title, message: text, preferredStyle: .alert)
        let cancel = UIAlertAction(title: Localized.string(.Common_Text_Cencel), style: .default)
        let ok = UIAlertAction(title: Localized.string(.Common_Text_OK), style: .destructive) { _ in
            completion()
        }
        alert.addAction(cancel)
        alert.addAction(ok)
        self.present(alert, animated: true)
    }
    
    func showTaskWarningAlert() {
        self.showAlertWithOK(title: Localized.string(.Recording_Popup_NoTaskWarningTitle), text: Localized.string(.Recording_Popup_NoTaskWarningDesc))
    }
}
