//
//  TLRko.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2023/12/10.
//  Copyright © 2023 FDEE. All rights reserved.
//

import Foundation

struct TLRko {
    static func value(key: TLRkey, op: String? = nil) -> String {
        var value: String = ""
        switch key {
        case .Update_Popup_HardUpdateTitle: value = "업데이트가 필요해요"
        case .Update_Popup_HardUpdateDesc: value = "최신버전으로 업데이트 해주세요"
        case .Update_Pupup_SoftUpdateTitle: value = "새로운 업데이트 알림"
        case .Update_Popup_SoftUpdateDesc: value = "{} 버전을 사용해보세요 :)"
        case .Update_Popup_Update: value = "업데이트"
        case .Update_Popup_NotNow: value = "나중에"
            
        case .ok: value = "확인"
        }
        
        if let op = op, value.contains("{}") {
            value = value.replacingOccurrences(of: "{}", with: "\(op)")
        }
        
        return value
    }
}
