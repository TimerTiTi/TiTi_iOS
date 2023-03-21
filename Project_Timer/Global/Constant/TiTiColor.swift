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
    static let startButton = UIColor(named: "startButtonColor")
    static let tabbarNonSelect = UIColor(named: "tabbarNonSelectColor")
    static let noTaskWarningRed = UIColor(named: "noTaskWarningRed")
    static let tabbarBackground = UIColor(named: "tabbarBackground")
    static func graphColor(num: Int) -> UIColor {
        return UIColor(named: "D\(num)") ?? .blue
    }
    static let systemBackground = UIColor(named: "system_backg")
}
