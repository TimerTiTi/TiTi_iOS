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
    
    func showAlertWithNumInput(title: String, text: String, placeHolder: String, completion: @escaping ((Int) -> Void)) {
        let alert = UIAlertController(title: title, message: text, preferredStyle: .alert)
        alert.addTextField { textField in
            textField.font = UIFont.systemFont(ofSize: 14)
            textField.textColor = .label
            textField.placeholder = placeHolder
            textField.textAlignment = .center
            textField.keyboardType = .numberPad
        }
        
        let cancel = UIAlertAction(title: Localized.string(.Common_Text_Cencel), style: .default)
        let update = UIAlertAction(title: Localized.string(.Common_Text_Done), style: .destructive) { _ in
            guard let text = alert.textFields?.first?.text,
                  let hour = Int(text) else { return }
            completion(hour)
        }
        alert.addAction(cancel)
        alert.addAction(update)
        
        self.present(alert, animated: true)
    }
    
    func showTaskWarningAlert() {
        self.showAlertWithOK(title: Localized.string(.Recording_Popup_NoTaskWarningTitle), text: Localized.string(.Recording_Popup_NoTaskWarningDesc))
    }
}
