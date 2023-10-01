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
        let ok = UIAlertAction(title: "OK", style: .default)
        alert.addAction(ok)
        self.present(alert, animated: true)
    }
    
    func showAlertWithOKAfterHandler(title: String, text: String, completion: @escaping(() -> Void)) {
        let alert = UIAlertController(title: title, message: text, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default) { _ in
            completion()
        }
        alert.addAction(ok)
        self.present(alert, animated: true)
    }
    
    func showRecordDateWarning(title: String, text: String, completion: @escaping(() -> Void)) {
        let alert = UIAlertController(title: title, message: text, preferredStyle: .alert)
        let cancel = UIAlertAction(title: "Cancel", style: .default) { _ in
            NotificationCenter.default.post(name: .removeNewRecordWarning, object: nil)
        }
        let ok = UIAlertAction(title: "OK", style: .destructive) { _ in
            completion()
        }
        alert.addAction(cancel)
        alert.addAction(ok)
        self.present(alert, animated: true)
    }
    
    func showTaskWarningAlert() {
        self.showAlertWithOK(title: "Create a new task".localized(), text: "before start recording, Create a new Task, and select that".localized())
    }
}
