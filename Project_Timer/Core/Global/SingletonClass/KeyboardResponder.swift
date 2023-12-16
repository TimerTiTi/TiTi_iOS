//
//  KeyboardResponder.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2023/10/11.
//  Copyright © 2023 FDEE. All rights reserved.
//

import SwiftUI

final class KeyboardResponder: ObservableObject {
    static let shared = KeyboardResponder()
    
    private var notificationCenter: NotificationCenter
    @Published private(set) var keyboardHeight: CGFloat = 0
    @Published private(set) var keyboardShow: Bool = false
    @Published private(set) var keyboardHide: Bool = false

    private init() {
        notificationCenter = .default
        addObserver()
    }
    
    func addObserver() {
        notificationCenter.addObserver(self, selector: #selector(keyBoardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(keyBoardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func removeObserver() {
        notificationCenter.removeObserver(self)
    }

    deinit {
        removeObserver()
    }

    @objc func keyBoardWillShow(notification: Notification) {
        if let keyboardSize = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
            keyboardHeight = keyboardSize.height
        }
        keyboardShow = true
    }

    @objc func keyBoardWillHide(notification: Notification) {
        keyboardHeight = 0
        keyboardShow = false
        keyboardHide = true
        Timer.scheduledTimer(withTimeInterval: 0.2, repeats: false) { [weak self] _ in
            self?.keyboardHide = false
        }
    }
}
