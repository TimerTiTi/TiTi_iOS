//
//  UIViewController+Extension.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2022/04/30.
//  Copyright © 2022 FDEE. All rights reserved.
//

import UIKit

extension UIViewController {
    func appTapGestureForDismissingKeyboard() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self,
            action: #selector(UIViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func showAlertWithOK(title: String, text: String) {
        let alert = UIAlertController(title: title, message: text, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default)
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
        self.showAlertWithOK(title: "Enter a new subject".localized(), text: "")
    }
    
    func updateTabbarColor(backgroundColor: UIColor?, tintColor: UIColor, normalColor: UIColor) {
        if #available(iOS 15.0, *){
            let appearance = UITabBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = backgroundColor
            
            appearance.compactInlineLayoutAppearance.normal.iconColor = normalColor
            appearance.compactInlineLayoutAppearance.normal.titleTextAttributes = [.foregroundColor : normalColor]
            
            appearance.inlineLayoutAppearance.normal.iconColor = normalColor
            appearance.inlineLayoutAppearance.normal.titleTextAttributes = [.foregroundColor : normalColor]
            
            appearance.stackedLayoutAppearance.normal.iconColor = normalColor
            appearance.stackedLayoutAppearance.normal.titleTextAttributes = [.foregroundColor : normalColor]
            
            self.tabBarController?.tabBar.standardAppearance = appearance
            self.tabBarController?.tabBar.scrollEdgeAppearance = appearance
            self.tabBarController?.tabBar.tintColor = tintColor
            
        } else {
            self.tabBarController?.tabBar.tintColor = tintColor
            self.tabBarController?.tabBar.unselectedItemTintColor = normalColor
            self.tabBarController?.tabBar.barTintColor = backgroundColor
        }
    }
}
