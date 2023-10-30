//
//  LoginSignupEnvironment.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2023/09/25.
//  Copyright © 2023 FDEE. All rights reserved.
//

import Foundation
import Combine
import SwiftUI

/// LoginSignupVC로 통신 역할
class LoginSignupEnvironment: ObservableObject {
    @Published var dismiss: Bool = false
    @Published var loginSuccess: Bool = false
    @Published var signupSuccess: Bool = false
    @Published var navigationPath = NavigationPath()
}
