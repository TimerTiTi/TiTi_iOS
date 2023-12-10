//
//  TLRkey.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2023/12/11.
//  Copyright © 2023 FDEE. All rights reserved.
//

import Foundation

enum TLRkey: String {
    /// 업데이트가 필요해요
    case Update_Popup_HardUpdateTitle
    /// 최신버전으로 업데이트 해주세요
    case Update_Popup_HardUpdateDesc
    /// 새로운 업데이트 알림
    case Update_Pupup_SoftUpdateTitle
    /// {} 버전을 사용해보세요 :)
    case Update_Popup_SoftUpdateDesc
    /// 업데이트
    case Update_Popup_Update
    /// 나중에
    case Update_Popup_NotNow
    
    /// 확인
    case ok
}
