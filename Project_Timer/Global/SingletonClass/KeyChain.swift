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
    private let service = Infos.APP_BUNDLE_ID.value
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
        
        switch status {
        case errSecSuccess:
            print("keychain save \(key.rawValue) success")
            return true
            
        case errSecDuplicateItem:
            print("keychain update \(key.rawValue)")
            return self.update(key: key, value: value)
            
        default:
            print("keychain save \(key.rawValue) fail: \(status.description)")
            return false
        }
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
        
        switch status {
        case errSecSuccess:
            // get value from item
            guard let existingItem = item as? [String : Any],
                  let valueData = existingItem[kSecAttrGeneric as String] as? Data,
                  let value = String(data: valueData, encoding: String.Encoding.utf8)
            else {
                print("keychain get \(key.rawValue) fail(decode): \(KeychainError.unexpectedData.localizedDescription)")
                return nil
            }
            
            print("keychain get \(key.rawValue) success")
            return value
            
        case errSecItemNotFound:
            print("keychain get \(key.rawValue) fail(notFound): \(KeychainError.noData.localizedDescription)")
            return nil
            
        default:
            print("keychain get \(key.rawValue) fail: \(status.description)")
            return nil
        }
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
        
        switch status {
        case errSecSuccess:
            print("keychain update \(key.rawValue) success")
            return true
            
        case errSecItemNotFound:
            print("keychain update \(key.rawValue) fail: \(KeychainError.noData.localizedDescription)")
            return false
            
        default:
            print("keychain update \(key.rawValue) fail: \(status.description)")
            return false
        }
    }
    
    /// delete keyChain[username, password, token]
    func deleteAll(_ service: String? = nil) -> Bool {
        let keys: [Key] = [.username, .password, .token]
        var result: Bool = true
        keys.forEach { key in
            if self.delete(key: key) == false {
                result = false
            }
        }
        
        switch result {
        case true:
            print("keychain deleteAll success")
            
        case false:
            print("keychain deleteAll fail")
        }
        
        return result
    }
    
    /// delete keyChain[{ kSecAttrService, kSecAttrAccount }]
    func delete(_ service: String? = nil, key: Key) -> Bool {
        let service = service != nil ? service! : self.service
        
        let query: [String: Any] = [kSecClass as String: kSecClassGenericPassword,
                                    kSecAttrService as String: service,
                                    kSecAttrAccount as String: key.rawValue]
        
        let status = SecItemDelete(query as CFDictionary)
        
        switch status {
        case errSecSuccess:
            print("keychain delete (\(key.rawValue)) success")
            return true
            
        case errSecItemNotFound:
            print("keychain delete (\(key.rawValue)) fail(notFound): \(status.description)")
            return false
            
        default:
            print("keychain delete (\(key.rawValue)) fail: \(status.description)")
            return false
        }
    }
}

extension OSStatus {
    public var description: String {
        let ns = SecCopyErrorMessageString(self, nil) as NSString?
        return ns as? String ?? ""
    }
}
