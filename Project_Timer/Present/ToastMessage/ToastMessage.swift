//
//  ToastMessage.swift
//  Project_Timer
//
//  Created by Ryeong on 6/27/24.
//  Copyright © 2024 FDEE. All rights reserved.
//

import Foundation
import SwiftUI

final class ToastMessage: UIView {
    
    static let shared = ToastMessage()
    
    private let height: CGFloat = 40
    private let presenter = ToastPresenter()
    private var toast: UIHostingController<AnyView>?
    private var animator: UIViewPropertyAnimator?
    
    private init() {
        super.init(frame: .zero)
        
        if let window = UIApplication.shared.firstWindow {
            window.addSubview(self)
            translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                centerXAnchor.constraint(equalTo: window.centerXAnchor),
                bottomAnchor.constraint(equalTo: window.topAnchor)
            ])
         
        }
        
        NotificationCenter.default.addObserver(forName: Notification.Name("updatedIsPresenting"), object: nil, queue: nil) { [weak self] notification in
            if let newValue = notification.userInfo?["newValue"] as? Bool {
                if let toast = self?.toast?.view, !newValue {
                    toast.removeFromSuperview()
                }
            }
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func show(type: ToastType) {
        if presenter.isPresenting {
            toast?.view.removeFromSuperview()
            presenter.isPresenting = false
        }
        setting(type)
        presenter.isPresenting = true
    }
    
    private func setting(_ type: ToastType) {
        presenter.height = height
        if !UIDevice.current.orientation.isLandscape {
            presenter.height += UIApplication.shared.safeAreaTopInset
        }
        
        switch type {
        case .newRecord:
            let toastView = ToastView(presenter: presenter) { presenter in
                newRecordToastView(presenter: presenter)
            }
            let toast = UIHostingController(rootView: AnyView(toastView))
            self.toast = toast
        }
        
        guard let toastView = self.toast?.view else { return }
        
        toastView.backgroundColor = .clear
        toastView.isHidden = true
        
        addSubview(toastView)
        // Constraints 설정
        toastView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            toastView.topAnchor.constraint(equalTo: self.topAnchor),
            toastView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            toastView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            toastView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
        ])
        
        toastView.isHidden = false
    }
}
