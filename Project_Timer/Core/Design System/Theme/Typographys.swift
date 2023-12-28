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
    enum Weight {
        case normal_3
        case semibold_4
        case bold_5
        case heavy_6
    }
    
    /// language 에 따른 font 반환
    static func font(_ weight: Weight, size: CGFloat) -> Font {
        let language = Language.current
        
        switch language {
        case .ko: return HGGGOTHICSSIP(weight, size)
        case .en: return HGGGOTHICSSIP(weight, size)
        case .zh: return MiSans(weight, size)
        }
    }
    
    /// 문장 languageCode에 따른 font 반환
    static func autoFont(_ string: String, _ weight: Weight, size: CGFloat) -> Font {
        if ["Chinese, Simplified"].contains(string.language()) {
            return MiSans(weight, size)
        } else {
            return HGGGOTHICSSIP(weight, size)
        }
    }
    
    /// UIKit 표시용 language에 따른 font 반환
    static func uifont(_ weight: Weight, size: CGFloat) -> UIFont? {
        let language = Language.current
        
        switch language {
        case .ko: return HGGGOTHICSSIP_uifont(weight, size)
        case .en: return HGGGOTHICSSIP_uifont(weight, size)
        case .zh: return MiSans_uifont(weight, size)
        }
    }
}

extension Typographys {
    // MARK: ko, en
    static func HGGGOTHICSSIP(_ weight: Weight, _ size: CGFloat) -> Font {
        switch weight {
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
    static func MiSans(_ weight: Weight, _ size: CGFloat) -> Font {
        switch weight {
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
    static func HGGGOTHICSSIP_uifont(_ weight: Weight, _ size: CGFloat) -> UIFont? {
        switch weight {
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
    static func MiSans_uifont(_ weight: Weight, _ size: CGFloat) -> UIFont? {
        switch weight {
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
