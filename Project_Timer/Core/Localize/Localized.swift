//
//  Localized.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2023/12/11.
//  Copyright © 2023 FDEE. All rights reserved.
//

import Foundation

// MARK: TLR 기반 lozalized string
struct Localized {
    static func string(_ key: TLRkey, op: String? = nil) -> String {
        let language = Language.current // OS 설정된 언어 + 사용자가 설정한 언어 -> 최종적인 언어값
        
        switch language {
        case .ko: return TLRko.value(key: key, op: op)
        case .en: return TLRen.value(key: key, op: op)
        case .zh: return TLRzh.value(key: key, op: op)
        }
    }
}
