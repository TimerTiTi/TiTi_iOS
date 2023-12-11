//
//  Typographys.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2023/12/11.
//  Copyright © 2023 FDEE. All rights reserved.
//

import Foundation
import SwiftUI
import UIKit

struct Typographys {
    enum Key {
        case extraLight
        case light
        case normal
        case semibold
        case bold
        case heavy
    }
    
    static func font(_ key: Key, size: CGFloat) -> Font {
        // MARK: 추후 UserDefaults 값 추가확인 필요
        let language = Language.system
        
        switch language {
        case .ko: return HGGGOTHICSSIP(key, size)
        case .en: return HGGGOTHICSSIP(key, size)
        case .zh: return MiSans(key, size)
        }
    }
    
    static func uifont(_ key: Key, size: CGFloat) -> UIFont? {
        // MARK: 추후 UserDefaults 값 추가확인 필요
        let language = Language.system
        
        switch language {
        case .ko: return HGGGOTHICSSIP_uifont(key, size)
        case .en: return HGGGOTHICSSIP_uifont(key, size)
        case .zh: return MiSans_uifont(key, size)
        }
    }
}

extension Typographys {
    // MARK: ko, en
    static func HGGGOTHICSSIP(_ key: Key, _ size: CGFloat) -> Font {
        switch key {
        case .extraLight:
            return Fonts.HGGGothicssiP00g(size: size)
        case .light:
            return Fonts.HGGGothicssiP20g(size: size)
        case .normal:
            return Fonts.HGGGothicssiP40g(size: size)
        case .semibold:
            return Fonts.HGGGothicssiP60g(size: size)
        case .bold:
            return Fonts.HGGGothicssiP80g(size: size)
        case .heavy:
            return Fonts.HGGGothicssiP99g(size: size)
        }
    }
    
    // MARK: zh
    static func MiSans(_ key: Key, _ size: CGFloat) -> Font {
        switch key {
        case .extraLight:
            return Fonts.MiSansExtraLight(size: size)
        case .light:
            return Fonts.MiSansLight(size: size)
        case .normal:
            return Fonts.MiSansNormal(size: size)
        case .semibold:
            return Fonts.MiSansMedium(size: size)
        case .bold:
            return Fonts.MiSansSemibold(size: size)
        case .heavy:
            return Fonts.MiSansBold(size: size)
        }
    }
}

extension Typographys {
    // MARK: ko, en
    static func HGGGOTHICSSIP_uifont(_ key: Key, _ size: CGFloat) -> UIFont? {
        switch key {
        case .extraLight:
            return Fonts.HGGGothicssiP00g(size: size)
        case .light:
            return Fonts.HGGGothicssiP20g(size: size)
        case .normal:
            return Fonts.HGGGothicssiP40g(size: size)
        case .semibold:
            return Fonts.HGGGothicssiP60g(size: size)
        case .bold:
            return Fonts.HGGGothicssiP80g(size: size)
        case .heavy:
            return Fonts.HGGGothicssiP99g(size: size)
        }
    }
    
    // MARK: zh
    static func MiSans_uifont(_ key: Key, _ size: CGFloat) -> UIFont? {
        switch key {
        case .extraLight:
            return Fonts.MiSansExtraLight(size: size)
        case .light:
            return Fonts.MiSansLight(size: size)
        case .normal:
            return Fonts.MiSansNormal(size: size)
        case .semibold:
            return Fonts.MiSansMedium(size: size)
        case .bold:
            return Fonts.MiSansSemibold(size: size)
        case .heavy:
            return Fonts.MiSansBold(size: size)
        }
    }
}
