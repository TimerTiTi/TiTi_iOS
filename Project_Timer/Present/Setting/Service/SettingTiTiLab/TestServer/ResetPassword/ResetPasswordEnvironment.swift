//
//  ResetPasswordEnvironment.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2024/03/16.
//  Copyright © 2024 FDEE. All rights reserved.
//

import SwiftUI
import UIKit
import Combine

/// ResetPasswordNicknameEnterVC로 통신 역할
final class ResetPasswordEnvironment: ObservableObject {
    weak var rootVC: UIViewController?
    @Published var dismiss: Bool = false
    @Published var resetSuccess: Bool = false
    @Published var navigationPath = NavigationPath()
    
    init(rootVC: UIViewController? = nil) {
        self.rootVC = rootVC
    }
    
    deinit {
        print("[ResetPasswordEnvironment] 👋")
        self.rootVC = nil
    }
}

