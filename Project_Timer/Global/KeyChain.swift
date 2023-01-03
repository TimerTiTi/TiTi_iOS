//
//  KeyChain.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2022/12/22.
//  Copyright © 2022 FDEE. All rights reserved.
//

import Foundation

final class KeyChain {
    static let shared = KeyChain()
    static let logined = Notification.Name("logined")
    static let logouted = Notification.Name("logouted")
    private let service = Bundle.main.infoDictionary?["PRODUCT_BUNDLE_IDENTIFIER"] as? String ?? "com.FDEE.TiTi"
    private init() {}
    
    enum KeychainError: Error {
        case noData
        case unexpectedData
        //        case unhandledError(status: OSStatus)
    }
    
    enum Key: String {
        case username
        case password
        case token
    }
    
    /// save keyChain[{ kSecAttrService, kSecAttrAccount }] = kSecAttrGeneric
    func save(_ service: String? = nil, key: Key, value: String) -> Bool {
        let service = service != nil ? service! : self.service
        // create data
        let valueData = value.data(using: String.Encoding.utf8)!
        // create query
        let query: [String: Any] = [kSecClass as String: kSecClassGenericPassword,
                                    kSecAttrService as String: service,
                                    kSecAttrAccount as String: key.rawValue,
                                    kSecAttrGeneric as String: valueData]
        
        // create Item
        let status = SecItemAdd(query as CFDictionary, nil)
        guard status == errSecSuccess else {
            print("keychain save \(key.rawValue) fail: \(status.description)")
            return false
        }
        
        return true
    }
    
    /// get kSecAttrGeneric = keyChain[{ kSecAttrService, kSecAttrAccount }]
    func get(_ service: String? = nil, key: Key) -> String? {
        let service = service != nil ? service! : self.service
        // create query for search
        let query: [String: Any] = [kSecClass as String: kSecClassGenericPassword,
                                    kSecAttrService as String: service,
                                    kSecAttrAccount as String: key.rawValue,
                                    kSecMatchLimit as String: kSecMatchLimitOne,
                                    kSecReturnAttributes as String: true,
                                    kSecReturnData as String: true]
        // get item
        var item: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &item)
        guard status != errSecItemNotFound else {
            print("keychain get \(key.rawValue) fail: \(KeychainError.noData.localizedDescription)")
            return nil
        }
        guard status == errSecSuccess else {
            print("keychain get \(key.rawValue) fail: \(status.description)")
            return nil
        }
        // get value from item
        guard let existingItem = item as? [String : Any],
              let valueData = existingItem[kSecAttrGeneric as String] as? Data,
              let value = String(data: valueData, encoding: String.Encoding.utf8)
        else {
            print("keychain get \(key.rawValue) fail: \(KeychainError.unexpectedData.localizedDescription)")
            return nil
        }
        
        return value
    }
    
    /// update keyChain[{ kSecAttrService, kSecAttrAccount }] = new kSecAttrGeneric
    func update(_ service: String? = nil, key: Key, value: String) -> Bool {
        let service = service != nil ? service! : self.service
        // create query for search
        let query: [String: Any] = [kSecClass as String: kSecClassGenericPassword,
                                    kSecAttrService as String: service,
                                    kSecAttrAccount as String: key.rawValue]
        
        let valueData = value.data(using: String.Encoding.utf8)!
        let attributes: [String: Any] = [kSecAttrAccount as String: key.rawValue,
                                         kSecAttrGeneric as String: valueData]
        
        let status = SecItemUpdate(query as CFDictionary, attributes as CFDictionary)
        guard status != errSecItemNotFound else {
            print("keychain update \(key.rawValue) fail: \(KeychainError.noData.localizedDescription)")
            return false
        }
        guard status == errSecSuccess else {
            print("keychain update \(key.rawValue) fail: \(status.description)")
            return false
        }
        
        return true
    }
    
    /// delete keyChain[username, password, token]
    func deleteAll(_ service: String? = nil) -> Bool {
        let secItemClasses = [kSecClassGenericPassword, kSecClassInternetPassword, kSecClassCertificate, kSecClassKey, kSecClassIdentity]
        for itemClass in secItemClasses {
            let spec: NSDictionary = [kSecClass: itemClass]
            SecItemDelete(spec)
        }
        return true
    }
    
    /// delete keyChain[{ kSecAttrService, kSecAttrAccount }]
    func delete(_ service: String? = nil, key: Key) -> Bool {
        let service = service != nil ? service! : self.service
        
        let query: [String: Any] = [kSecClass as String: kSecClassGenericPassword,
                                    kSecAttrService as String: service,
                                    kSecAttrAccount as String: key.rawValue,
                                    kSecMatchLimit as String: kSecMatchLimitOne,
                                    kSecReturnAttributes as String: true,
                                    kSecReturnData as String: true]
        
        let status = SecItemDelete(query as CFDictionary)
        guard status == errSecSuccess || status == errSecItemNotFound else {
            print("keychain delete \(key.rawValue) fail: \(status.description)")
            return false
        }
        
        return true
    }
}

extension OSStatus {
    public var description: String {
        let ns = SecCopyErrorMessageString(self, nil) as NSString?
        return ns as? String ?? ""
    }
}
