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
    private var retryCount: Int = 3
    
    public func show(toast: Toast) {
        guard !toastViewModel.isVisible else { return }
        guard let keyWindow = UIApplication.shared.keyWindow else {
            // 아직 window 가 활성화되기 전
            // retry 만료된 경우 toast 표시 안함
            guard retryCount > 1 else { return }
            retryCount -= 1
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
                guard let self else { return }
                show(toast: toast)
            }
            return
        }
        
        retryCount = 3
        let toastView: some ToastView = {
            switch toast {
            case .newRecord(let date):
                return NewRecordToastView(recordDate: date)
            }
        }()
        
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            
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
    }
    
    private func bind() {
        toastViewModel.$isVisible
            .dropFirst()
            .filter { !$0 }
            .sink { [weak self] _ in
                DispatchQueue.main.async { [weak self] in
                    self?.toastHosting?.view.removeFromSuperview()
                    self?.toastHosting = nil
                }
            }
            .store(in: &cancellables)
    }
}
