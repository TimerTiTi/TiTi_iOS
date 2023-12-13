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
        case extraLight_1
        case light_2
        case normal_3
        case semibold_4
        case bold_5
        case heavy_6
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
    
    static func autoFont(_ string: String, _ key: Key, size: CGFloat) -> Font {
        print(string, string.language())
        if ["Chinese, Simplified"].contains(string.language()) {
            return MiSans(key, size)
        } else {
            return HGGGOTHICSSIP(key, size)
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
        case .extraLight_1:
            return Fonts.HGGGothicssiP00g(size: size)
        case .light_2:
            return Fonts.HGGGothicssiP20g(size: size)
        case .normal_3:
            return Fonts.HGGGothicssiP40g(size: size)
        case .semibold_4:
            return Fonts.HGGGothicssiP60g(size: size)
        case .bold_5:
            return Fonts.HGGGothicssiP80g(size: size)
        case .heavy_6:
            return Fonts.HGGGothicssiP99g(size: size)
        }
    }
    
    // MARK: zh
    static func MiSans(_ key: Key, _ size: CGFloat) -> Font {
        switch key {
        case .extraLight_1:
            return Fonts.MiSansExtraLight(size: size)
        case .light_2:
            return Fonts.MiSansLight(size: size)
        case .normal_3:
            return Fonts.MiSansNormal(size: size)
        case .semibold_4:
            return Fonts.MiSansRegular(size: size)
        case .bold_5:
            return Fonts.MiSansDemibold(size: size)
        case .heavy_6:
            return Fonts.MiSansBold(size: size)
        }
    }
}

extension Typographys {
    // MARK: ko, en
    static func HGGGOTHICSSIP_uifont(_ key: Key, _ size: CGFloat) -> UIFont? {
        switch key {
        case .extraLight_1:
            return Fonts.HGGGothicssiP00g(size: size)
        case .light_2:
            return Fonts.HGGGothicssiP20g(size: size)
        case .normal_3:
            return Fonts.HGGGothicssiP40g(size: size)
        case .semibold_4:
            return Fonts.HGGGothicssiP60g(size: size)
        case .bold_5:
            return Fonts.HGGGothicssiP80g(size: size)
        case .heavy_6:
            return Fonts.HGGGothicssiP99g(size: size)
        }
    }
    
    // MARK: zh
    static func MiSans_uifont(_ key: Key, _ size: CGFloat) -> UIFont? {
        switch key {
        case .extraLight_1:
            return Fonts.MiSansExtraLight(size: size)
        case .light_2:
            return Fonts.MiSansLight(size: size)
        case .normal_3:
            return Fonts.MiSansNormal(size: size)
        case .semibold_4:
            return Fonts.MiSansMedium(size: size)
        case .bold_5:
            return Fonts.MiSansSemibold(size: size)
        case .heavy_6:
            return Fonts.MiSansBold(size: size)
        }
    }
}
