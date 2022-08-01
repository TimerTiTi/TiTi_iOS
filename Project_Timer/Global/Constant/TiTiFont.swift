//
//  TiTiFont.swift
//  Project_Timer
//
//  Created by 최수정 on 2022/07/01.
//  Copyright © 2022 FDEE. All rights reserved.
//

import SwiftUI

enum TiTiFont {
    static func HGGGothicssi(size: CGFloat, weight: UIFont.Weight) -> Font {
        let weightValue: String
        
        switch weight {
        case .ultraLight, .thin, .light:
            weightValue = "00"
        case .regular, .medium:
            weightValue = "20"
        case .semibold:
            weightValue = "40"
        case .bold:
            weightValue = "60"
        case .heavy:
            weightValue = "80"
        case .black:
            weightValue = "99"
        default:
            weightValue = "60"
        }
        
        return Font.custom("HGGGothicssiP\(weightValue)g", size: size)
    }
    
    static func HGGGothicssiP60g(size: CGFloat) -> UIFont? {
        return UIFont(name: "HGGGothicssiP60g", size: size)
    }
    static func HGGGothicssiP80g(size: CGFloat) -> UIFont? {
        return UIFont(name: "HGGGothicssiP80g", size: size)
    }
}
