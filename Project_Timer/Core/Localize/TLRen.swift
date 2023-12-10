//
//  TLRen.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2023/12/10.
//  Copyright © 2023 FDEE. All rights reserved.
//

import Foundation

struct TLRen {
    static func value(key: TLRkey, op: String? = nil) -> String {
        var value: String = ""
        switch key {
        case .Update_Popup_HardUpdateTitle: value = "You have to update the app"
        case .Update_Popup_HardUpdateDesc: value = "Please update the latest version"
        case .Update_Pupup_SoftUpdateTitle: value = "New Version"
        case .Update_Popup_SoftUpdateDesc: value = "Try {} version"
        case .Update_Popup_Update: value = "Update"
        case .Update_Popup_NotNow: value = "Not Now"
            
        case .ok: value = "ok"
        }
        
        if let op = op, value.contains("{}") {
            value = value.replacingOccurrences(of: "{}", with: "\(op)")
        }
        
        return value
    }
}
