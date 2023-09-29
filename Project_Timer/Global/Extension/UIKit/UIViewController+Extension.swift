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
    func appTapGestureForDismissingKeyboard() {
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
    
    // MARK: NavigationBar
    func configureNavigationStyle(color: UIColor = .white) {
        self.navigationController?.navigationBar.tintColor = color
        self.navigationItem.largeTitleDisplayMode = .never
        
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 15)]
        self.navigationController?.navigationBar.topItem?.title = ""
        
        self.tabBarController?.tabBar.isHidden = true
    }
    
    func disableNavigationStyle() {
        self.navigationController?.navigationBar.tintColor = .tintColor
        self.navigationItem.largeTitleDisplayMode = .automatic
        
        self.tabBarController?.tabBar.isHidden = false
    }
    
    func configurePortraitOrientationForIphone() {
        if UIDevice.current.userInterfaceIdiom == .phone {
            AppDelegate.shared.shouldSupportPortraitOrientation = true
        }
    }
    
    func disablePortraitOrientationForIphone() {
        if UIDevice.current.userInterfaceIdiom == .phone {
            AppDelegate.shared.shouldSupportPortraitOrientation = false
        }
    }
}
