//
//  ToastManager.swift
//  Project_Timer
//
//  Created by Minsang on 5/2/25.
//  Copyright © 2025 FDEE. All rights reserved.
//

import UIKit
import SwiftUI
import Combine

final class ToastManager {
    static let shared = ToastManager()
    private init() {
        bind()
    }
    
    private let toastViewModel = ToastViewModel()
    private var toastHosting: UIHostingController<AnyView>?
    private var cancellables: Set<AnyCancellable> = []
    
    public func show(toast: Toast) {
        guard !toastViewModel.isVisible else { return }
        guard let keyWindow = UIApplication.shared.keyWindow else { return }
        
        let toastView: some ToastView = {
            switch toast {
            case .newRecord(let date):
                return NewRecordToastView(recordDate: date)
            }
        }()
        
        let toastPresenter = ToastViewPresenter(content: toastView, toastViewModel: toastViewModel)
        let toastHosting = UIHostingController(rootView: AnyView(toastPresenter))
        toastHosting.view.backgroundColor = .clear
        self.toastHosting = toastHosting
        keyWindow.addSubview(toastHosting.view)
        toastHosting.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            toastHosting.view.centerXAnchor.constraint(equalTo: keyWindow.centerXAnchor),
            toastHosting.view.topAnchor.constraint(equalTo: keyWindow.topAnchor)
        ])
        
        toastViewModel.action(.startAnimation)
    }
    
    private func bind() {
        toastViewModel.$isVisible
            .dropFirst()
            .filter { !$0 }
            .sink { [weak self] _ in
                self?.toastHosting?.view.removeFromSuperview()
                self?.toastHosting = nil
            }
            .store(in: &cancellables)
    }
}
