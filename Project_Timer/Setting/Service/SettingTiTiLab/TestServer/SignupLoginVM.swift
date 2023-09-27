//
//  SignupLoginVM.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2023/09/27.
//  Copyright © 2023 FDEE. All rights reserved.
//

import Foundation

final class SignupLoginVM {
    let isLogin: Bool
    let network: TestServerAuthFetchable
    
    init(isLogin: Bool, network: TestServerAuthFetchable) {
        self.isLogin = isLogin
        self.network = network
    }
}
