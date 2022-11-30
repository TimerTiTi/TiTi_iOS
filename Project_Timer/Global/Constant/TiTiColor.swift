//
//  TiTiColor.swift
//  Project_Timer
//
//  Created by 최수정 on 2022/07/01.
//  Copyright © 2022 FDEE. All rights reserved.
//

import UIKit

enum TiTiColor {
    static let shadow = UIColor(named: "shadow")
    static let background = UIColor(named: "Background")
    static let background2 = UIColor(named: "Background2")
    static let blue = UIColor(named: "Blue")
    static let button = UIColor(named: "Button")
    static let click = UIColor(named: "Click")
    static let text = UIColor(named: "Text")
    static let innerColor = UIColor(named: "innerColor")
    static let darkRed = UIColor(named: "darkRed")
    static let dock = UIColor(named: "dock")
    static let startButton = UIColor(named: "startButtonColor")
    static let tabbarNonSelect = UIColor(named: "tabbarNonSelectColor")
    static let lightpink = UIColor(named: "lightpink")
    static let D1 = UIColor(named: "D1")
    static let D2 = UIColor(named: "D2")
    static let tabbarBackground = UIColor(named: "tabbarBackground")
    static func graphColor(num: Int) -> UIColor {
        return UIColor(named: "D\(num)") ?? .blue
    }
    static let systemBackground = UIColor(named: "system_backg")
}
