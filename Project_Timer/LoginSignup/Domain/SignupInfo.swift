//
//  SignupInfo.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2023/10/29.
//  Copyright © 2023 FDEE. All rights reserved.
//

import Foundation
import Combine

/// 회원가입 정보
class SignupInfo: ObservableObject {
    enum type {
        case normal
        case vender
        case venderWithEmail
    }
    enum vender {
        case apple
        case google
    }
    
    let type: SignupInfo.type
    let vender: SignupInfo.vender?
    let id: String?
    
    @Published var email: String?
    @Published var password: String?
    @Published var nickname: String?
    @Published var marketingObservable: Bool = false
    private(set) var verificationKey: String?
    
    init() {
        self.type = .normal
        self.vender = nil
        self.id = nil
    }
    
    init(type: SignupInfo.type, vender: SignupInfo.vender, id: String) {
        self.type = type
        self.vender = vender
        self.id = id
    }
    
    func setVerificationKey(to verificationKey: String) {
        self.verificationKey = verificationKey
    }
    
    func removeVerificationKey() {
        self.verificationKey = nil
    }
}
