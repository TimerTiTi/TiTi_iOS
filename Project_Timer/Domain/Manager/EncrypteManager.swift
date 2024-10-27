//
//  EncrypteManager.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2024/10/13.
//  Copyright © 2024 FDEE. All rights reserved.
//

import Foundation
import CryptoKit

/// 암호화 Manager
struct EncrypteManager {
    /// 대칭키 문자열을 토대로 symmetricKey, iv 값 반환
    static var symmetricKeyAndIV: (symmetricKey: SymmetricKey, iv: Data)? {
        // UTF-8 인코딩 된 32자 대칭키 문자열
        let symmetricKeyString = Infos.TITI_DEV_CRYPTO_SECRET.value
        
        // 1. UTF-8로 인코딩된 문자열을 바이트 배열 ([UInt8])로 변환
        let symmetricKeyByteArray = Array(symmetricKeyString.utf8)
        
        // 2. 바이트 배열을 16진수 문자열(String)으로 변환
        let hexString = symmetricKeyByteArray.map { String(format: "%02x", $0) }.joined()
        
        // 3. IV 값은 앞 16바이트를 UTF8로 디코딩한 값으로 사용
        let ivString = hexString.prefix(16)
        
        // 4. sysmettricKey, ivData 반환
        guard let keyData = symmetricKeyString.data(using: .utf8),
              let ivData = ivString.data(using: .utf8) else {
            print("Error: Failed to decode UTF-8 string to data.")
            return nil
        }
        
        return (symmetricKey: SymmetricKey(data: keyData), iv: ivData)
    }

    /// 평문과 대칭키를 토대로 AES-256 GCM 암호화를 base64url로 인코딩된 값으로 반환
    static func encryptAES256GCM(plaintext: String) throws -> String {
        // 대칭키 값, IV 값
        guard let (symmetricKey, ivData) = Self.symmetricKeyAndIV,
              let nonce = try? AES.GCM.Nonce(data: ivData) else {
            print("ERROR: can't get symmetricKey and ivData.")
            return ""
        }
        
        // 1. 평문을 바이트 배열 ([UInt8])로 변환
        let inputData = Array(plaintext.utf8)

        // 2. AES-GCM으로 암호화 수행
        let sealedBox = try AES.GCM.seal(inputData, using: symmetricKey, nonce: nonce)

        // 3. ciphertext + tag를 결합하여 암호화 데이터 생성
        let combinedData = sealedBox.ciphertext + sealedBox.tag

        // 4. 암호화된 데이터를 base64url로 인코딩
        let base64urlEncoded = combinedData.base64EncodedString(options: .endLineWithLineFeed)
            .replacingOccurrences(of: "+", with: "-")
            .replacingOccurrences(of: "/", with: "_")
            .replacingOccurrences(of: "=", with: "")

        return base64urlEncoded
    }
}
