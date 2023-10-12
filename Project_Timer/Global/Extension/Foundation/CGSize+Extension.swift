//
//  CGSize+Extension.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2023/09/26.
//  Copyright © 2023 FDEE. All rights reserved.
//

import Foundation
import UIKit

extension CGSize {
    enum DeviceDetailType: CGFloat {
        case iPad12 = 1024
        case iPad11 = 834
        case iPadMini = 744
        case iPhoneMax = 430
        case iPhonePro = 390
        case iPhoneMini = 375
    }
    
    enum DeviceLandspace: CGFloat {
        case iPad12 = 1366
        case iPad11 = 1194
        case iPadMini = 1133
        case iPhoneMax = 932
        case iPhonePro = 844
        case iPhoneMini = 667
    }
    
    /// 가로, 세로 중 작은값
    var minLength: CGFloat {
        return min(self.width, self.height)
    }
    
    /// minLength 값을 기준으로 디바이스 상세 형태 분기 값
    var deviceDetailType: DeviceDetailType {
        let min = minLength
        let max = max(self.width, self.height)
        
        // iPad
        if min > DeviceDetailType.iPhoneMax.rawValue {
            switch UIDevice.current.orientation {
            case .landscapeLeft, .landscapeRight:
                if max >= DeviceLandspace.iPad12.rawValue {
                    return .iPad12
                } else if max >= DeviceLandspace.iPad11.rawValue {
                    return .iPad11
                } else {
                    return .iPadMini
                }
            default:
                if min >= DeviceDetailType.iPad12.rawValue {
                    return .iPad12
                } else if min >= DeviceDetailType.iPad11.rawValue {
                    return .iPad11
                } else {
                    return .iPadMini
                }
            }
        }
        // iPhone
        else {
            if min >= 428 { // 428 ~ 430 이내만 iPhoneMax UI 표시
                return .iPhoneMax
            } else if min >= DeviceDetailType.iPhonePro.rawValue {
                return .iPhonePro
            } else {
                return .iPhoneMini
            }
        }
    }
}
