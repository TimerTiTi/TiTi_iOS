//
//  TLRzh.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2023/12/10.
//  Copyright © 2023 FDEE. All rights reserved.
//

import Foundation

struct TLRzh {
    static func value(key: TLRkey, op: String? = nil) -> String {
        var value: String = ""
        switch key {
        case .Update_Popup_HardUpdateTitle: value = "需要更新"
        case .Update_Popup_HardUpdateDesc: value = "请更新到最新版本"
        case .Update_Pupup_SoftUpdateTitle: value = "新版本发布"
        case .Update_Popup_SoftUpdateDesc: value = "{} 请使用版本"
        case .Update_Popup_Update: value = "更新"
        case .Update_Popup_NotNow: value = "不是现在"
            
        case .ok: value = "确认"
        }
        
        if let op = op, value.contains("{}") {
            value = value.replacingOccurrences(of: "{}", with: "\(op)")
        }
        
        return value
    }
}
