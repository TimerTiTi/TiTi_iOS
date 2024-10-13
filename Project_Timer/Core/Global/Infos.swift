//
//  Infos.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2023/09/25.
//  Copyright © 2023 FDEE. All rights reserved.
//

import Foundation

/// xcconfig 파일기반 env 값
enum Infos: String {
    /// scheme 값, dev 값이면 TimerTiTi (dev) 용 앱으로 빌드
    case MODE
    /// Node.js 서버 URL, 현재는 Firestore로부터 URL을 받아 사용중 (해당 값 미사용중)
    case ServerURL2
    /// TiTi Firestore URL, 최신 버전, 업데이트 내역 등을 수신받기 위한 도메인
    case FirestoreURL
    /// 앱의 bundle identifier 값
    case APP_BUNDLE_ID
    /// admob 광고의 ad id 값
    case ADMOB_AD_ID
    /// TiTi 서버간의 AES-256 암호화 대칭키 값
    case TITI_DEV_CRYPTO_SECRET
    
    var value: String {
        return Bundle.main.infoDictionary?[self.rawValue] as? String ?? ""
    }
    
    static var isDevMode: Bool {
        return Infos.MODE.value == "dev"
    }
}
