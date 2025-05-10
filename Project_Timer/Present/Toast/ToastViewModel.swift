//
//  ToastViewModel.swift
//  Project_Timer
//
//  Created by Minsang on 5/2/25.
//  Copyright © 2025 FDEE. All rights reserved.
//

import SwiftUI

final class ToastViewModel: ObservableObject {
    
    // MARK: State & Action
    
    @Published private(set) var isVisible: Bool = false
    
    enum Action {
        case startAnimation
        case removeToast
    }
    
    init() {}
    
}

// MARK: Action

extension ToastViewModel {
    
    public func action(_ action: Action) {
        switch action {
        case .startAnimation:
            startAnimation()
        case .removeToast:
            removeToast()
        }
    }
    
    private func startAnimation() {
        isVisible = true
    }
    
    private func removeToast() {
        isVisible = false
    }
    
}
