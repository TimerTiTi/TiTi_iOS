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
    /// 대칭키 값
    static var symmetricKey: SymmetricKey {
        // 대칭키 문자열
        let symmetricKeyString = Infos.TITI_DEV_CRYPTO_SECRET.value
        
        // 문자열을 UTF-8 데이터로 변환
        let keyData = Data(symmetricKeyString.utf8)
        
        // AES-256 키는 32바이트여야 하므로 데이터 길이를 확인
        if keyData.count == 32 {
            // 32바이트이면 SymmetricKey 생성
            return SymmetricKey(data: keyData)
        } else {
            print("Error: AES-256 requires a 32-byte key.")
            return SymmetricKey(data: keyData)
        }
    }
    
    /// 평문과 대칭키를 토대로 AES-256 GCM 암호화를 base64url로 인코딩된 값으로 반환
    static func encryptAES256GCM(plaintext: String, symmetricKey: SymmetricKey = Self.symmetricKey) throws -> String {
        // 입력 문자열을 Data로 변환
        let inputData = Data(plaintext.utf8)

        // 암호화에 사용할 nonce 생성 (GCM에서는 12바이트 권장)
        let nonce = AES.GCM.Nonce()

        // AES-GCM으로 암호화 수행
        let sealedBox = try AES.GCM.seal(inputData, using: symmetricKey, nonce: nonce)

        // nonce + ciphertext + tag를 결합하여 암호화 데이터 생성
        let combinedData = nonce + sealedBox.ciphertext + sealedBox.tag

        // 암호화된 데이터를 base64url로 인코딩
        let base64urlEncoded = combinedData.base64EncodedString(options: .endLineWithLineFeed)
            .replacingOccurrences(of: "+", with: "-")
            .replacingOccurrences(of: "/", with: "_")
            .replacingOccurrences(of: "=", with: "")

        print("[AES-256] before: \(plaintext) -> after: \(base64urlEncoded)")
        return base64urlEncoded
    }
}
