//
//  EncrypteManager.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2024/10/13.
//  Copyright © 2024 FDEE. All rights reserved.
//

import Foundation
import CryptoKit

// key -> 16진수 변환 -> utf8로 인코딩 -> 16바이트를 utf8로 디코딩 -> iv 값

/// 암호화 Manager
struct EncrypteManager {
    /// 대칭키 값
    static var symmetricKeyAndIV: (symmetricKey: SymmetricKey, iv: Data)? {
        // UTF-8 인코딩 된 32자 대칭키 문자열
        let symmetricKeyString = Infos.TITI_DEV_CRYPTO_SECRET.value
        
        // 1. UTF-8로 인코딩된 문자열을 바이트 배열로 변환
        
        guard let keyData = symmetricKeyString.data(using: .utf8) else {
            print("Error: Failed to decode UTF-8 string to data.")
            return nil
        }
        
        // 2. 바이트 배열을 16진수 문자열로 변환하는 함수
        func byteArrayToHexString(_ byteArray: [UInt8]) -> String {
            return byteArray.map { String(format: "%02x", $0) }.joined()
        }
        
//        // 3. 바이트 배열을 16진수 문자열로 변환
//        let hexString = byteArrayToHexString(keyData)
        
//        // 4. 16진수 문자열에서 앞의 16바이트(32자)를 추출
//        let ivHexString = String(hexString.prefix(32)) // 앞의 32자 (16바이트)

        // 5. 16진수 문자열을 다시 바이트 배열로 변환하는 함수
//        func stringToByteArray(_ hex: String) -> [UInt8]? {
//            var byteArray = [UInt8]()
//            var index = hex.startIndex
//            while index < hex.endIndex {
//                let nextIndex = hex.index(index, offsetBy: 2)
//                let byteString = hex[index..<nextIndex]
//                if let byte = UInt8(byteString, radix: 16) {
//                    byteArray.append(byte)
//                } else {
//                    return nil
//                }
//                index = nextIndex
//            }
//            return byteArray
//        }
        
        func stringToByteArray(_ string: String) -> [UInt8] {
            return Array(string.utf8) // UTF-8로 인코딩하여 [UInt8] 배열로 변환
        }
        
        // 1
        let symmetricKeyByteArray = stringToByteArray(symmetricKeyString)
        
        // 2
        let hexString = byteArrayToHexString(symmetricKeyByteArray)
        print("hexString: \(hexString)")
        
        // 3
        let ivString = hexString.prefix(16)
        print("ivString: \(ivString)")
        guard let ivData = ivString.data(using: .utf8) else {
            print("error")
            return nil
        }
        
        return (symmetricKey: SymmetricKey(data: keyData), iv: ivData)
//
//
//        // 6. 추출한 16진수 문자열을 다시 바이트 배열로 변환 (IV로 사용)
//        guard let ivData = hexStringToByteArray(symmetricKeyString) else {
//            print("Error: Failed to convert hex string to byte array for IV.")
//            return nil
//        }
//        print("ivString: \(String(bytes: ivData, encoding: .utf8))")
//        
//        // 7. 남은 바이트 배열을 AES-256 대칭키로 사용 (여기서는 전체 keyData 사용)
//        let symmetricKey = SymmetricKey(data: keyData)
//        
//        // 8. SymmetricKey와 IV(byte array)를 함께 반환
//        return (symmetricKey: symmetricKey, iv: ivData)
    }

    
    /// 평문과 대칭키를 토대로 AES-256 GCM 암호화를 base64url로 인코딩된 값으로 반환
    static func encryptAES256GCM(plaintext: String) throws -> String {
        // 대칭키 값, IV 값
        guard let (symmetricKey, ivData) = Self.symmetricKeyAndIV,
              let nonce = try? AES.GCM.Nonce(data: ivData) else {
            return ""
        }
        
        print(symmetricKey, ivData)
        
        // 입력 문자열을 Data로 변환
        let inputData = Array(plaintext.utf8)

        // AES-GCM으로 암호화 수행
        let sealedBox = try AES.GCM.seal(inputData, using: symmetricKey, nonce: nonce)

        // nonce + ciphertext + tag를 결합하여 암호화 데이터 생성
        let combinedData = sealedBox.ciphertext + sealedBox.tag

        // 암호화된 데이터를 base64url로 인코딩
        let base64urlEncoded = combinedData.base64EncodedString(options: .endLineWithLineFeed)
            .replacingOccurrences(of: "+", with: "-")
            .replacingOccurrences(of: "/", with: "_")
            .replacingOccurrences(of: "=", with: "")

        print("[AES-256] before: \(plaintext) -> after: \(base64urlEncoded)")
        return base64urlEncoded
    }
}

extension EncrypteManager {
    static func test() {
        let plainText: String = "plainText1!"
        
        if let after: String = try? Self.encryptAES256GCM(plaintext: plainText) {
            print("before: \(plainText)")
            print("after: \(after)")
        }
        
        let deviceId = UUID()
        print(deviceId.uuidString)
    
    }
}
