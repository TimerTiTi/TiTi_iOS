//
//  CGSize+Extension.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2023/09/26.
//  Copyright © 2023 FDEE. All rights reserved.
//

import Foundation

extension CGSize {
    enum DeviceDetailType: CGFloat {
        case iPad12 = 1024
        case iPad11 = 834
        case iPadMini = 744
        case iPhoneMax = 430
        case iPhonePro = 390
        case iPhoneMini = 375
    }
    
    enum DeviceType {
        case iPad
        case iPhone
    }
    
    /// 가로, 세로 중 작은값
    var minLength: CGFloat {
        return min(self.width, self.height)
    }
    
    /// minLength 값을 기준으로 디바이스 형태 분기 값
    var deviceType: DeviceType {
        let width = minLength
        
        if width > DeviceDetailType.iPhoneMax.rawValue {
            return .iPad
        } else {
            return .iPhone
        }
    }
    
    /// minLength 값을 기준으로 디바이스 상세 형태 분기 값
    var deviceDetailType: DeviceDetailType {
        let width = minLength
        
        // iPad
        if width > DeviceDetailType.iPhoneMax.rawValue {
            if width >= DeviceDetailType.iPad12.rawValue {
                return .iPad12
            } else if width >= DeviceDetailType.iPad11.rawValue {
                return .iPad11
            } else {
                return .iPadMini
            }
        }
        // iPhone
        else {
            if width >= 428 { // 428 ~ 430 이내만 iPhoneMax UI 표시
                return .iPhoneMax
            } else if width >= DeviceDetailType.iPhonePro.rawValue {
                return .iPhonePro
            } else {
                return .iPhoneMini
            }
        }
    }
}
