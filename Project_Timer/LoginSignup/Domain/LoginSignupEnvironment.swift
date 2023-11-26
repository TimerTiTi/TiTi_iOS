//
//  LoginSignupEnvironment.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2023/09/25.
//  Copyright © 2023 FDEE. All rights reserved.
//

import SwiftUI
import UIKit
import Combine

/// LoginSignupVC로 통신 역할
class LoginSignupEnvironment: ObservableObject {
    weak var rootVC: UIViewController?
    @Published var dismiss: Bool = false
    @Published var loginSuccess: Bool = false
    @Published var signupSuccess: Bool = false
    @Published var navigationPath = NavigationPath()
    
    init(rootVC: UIViewController? = nil) {
        self.rootVC = rootVC
    }
    
    deinit {
        self.rootVC = nil
    }
}
