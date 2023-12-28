//
//  Fonts.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2023/12/11.
//  Copyright © 2022 FDEE. All rights reserved.
//

import SwiftUI

enum Fonts {
    static func HGGGothicssiP40g(size: CGFloat) -> Font {
        return Font.custom("HGGGothicssiP40g", size: size)
    }
    static func HGGGothicssiP60g(size: CGFloat) -> Font {
        return Font.custom("HGGGothicssiP60g", size: size)
    }
    static func HGGGothicssiP80g(size: CGFloat) -> Font {
        return Font.custom("HGGGothicssiP80g", size: size)
    }
    static func HGGGothicssiP99g(size: CGFloat) -> Font {
        return Font.custom("HGGGothicssiP99g", size: size)
    }
    
    static func MiSansNormal(size: CGFloat) -> Font {
        return Font.custom("MiSans-Normal", size: size)
    }
    static func MiSansRegular(size: CGFloat) -> Font {
        return Font.custom("MiSans-Regular", size: size)
    }
    static func MiSansDemibold(size: CGFloat) -> Font {
        return Font.custom("MiSans-Demibold", size: size)
    }
    static func MiSansBold(size: CGFloat) -> Font {
        return Font.custom("MiSans-Bold", size: size)
    }
}

// MARK: UIFont
extension Fonts {
    static func HGGGothicssiP40g(size: CGFloat) -> UIFont? {
        return UIFont(name: "HGGGothicssiP40g", size: size)
    }
    static func HGGGothicssiP60g(size: CGFloat) -> UIFont? {
        return UIFont(name: "HGGGothicssiP60g", size: size)
    }
    static func HGGGothicssiP80g(size: CGFloat) -> UIFont? {
        return UIFont(name: "HGGGothicssiP80g", size: size)
    }
    static func HGGGothicssiP99g(size: CGFloat) -> UIFont? {
        return UIFont(name: "HGGGothicssiP99g", size: size)
    }
    
    static func MiSansNormal(size: CGFloat) -> UIFont? {
        return UIFont(name: "MiSans-Normal", size: size)
    }
    static func MiSansRegular(size: CGFloat) -> UIFont? {
        return UIFont(name: "MiSans-Regular", size: size)
    }
    static func MiSansDemibold(size: CGFloat) -> UIFont? {
        return UIFont(name: "MiSans-Demibold", size: size)
    }
    static func MiSansBold(size: CGFloat) -> UIFont? {
        return UIFont(name: "MiSans-Bold", size: size)
    }
}
