//
//  KeyChain.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2022/12/22.
//  Copyright © 2022 FDEE. All rights reserved.
//

import Foundation
import SwiftKeychainWrapper

final class KeyChain {
    static let shared = KeyChain()
    static let logined = Notification.Name("logined")
    static let logouted = Notification.Name("logouted")
    private init() {}
    
    func save(key: KeychainWrapper.Key, value: String) {
        KeychainWrapper.standard[key] = value
    }
    
    func get(key: KeychainWrapper.Key) -> String? {
        return KeychainWrapper.standard[key]
    }
    
    func deleteAll() {
        KeychainWrapper.standard.remove(forKey: .username)
        KeychainWrapper.standard.remove(forKey: .password)
        KeychainWrapper.standard.remove(forKey: .token)
    }
}

extension KeychainWrapper.Key {
    static let username: KeychainWrapper.Key = "username"
    static let password: KeychainWrapper.Key = "password"
    static let token: KeychainWrapper.Key = "token"
}
