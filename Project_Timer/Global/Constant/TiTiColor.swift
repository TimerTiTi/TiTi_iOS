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
    static let timerBackground = UIColor(named: "timerBackground")
    static let stopwatchBackground = UIColor(named: "stopwatchBackground")
    static let warningRed = UIColor(named: "warningRed")
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
