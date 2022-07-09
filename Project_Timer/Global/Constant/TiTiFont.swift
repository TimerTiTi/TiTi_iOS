//
//  TiTiFont.swift
//  Project_Timer
//
//  Created by 최수정 on 2022/07/01.
//  Copyright © 2022 FDEE. All rights reserved.
//

import SwiftUI

enum TiTiFont {
    static func HGGGothicssiP60g(size: CGFloat) -> Font {
        return Font.custom("HGGGothicssiP60g", size: size)
    }
    static func HGGGothicssiP60g(size: CGFloat) -> UIFont? {
        return UIFont(name: "HGGGothicssiP60g", size: size)
    }
}