//
//  Colors.swift
//  Project_Timer
//
//  Created by 최수정 on 2022/07/01.
//  Copyright © 2022 FDEE. All rights reserved.
//

import UIKit

enum Colors: String {
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
    
    /* 회원 정보 관리 */
    static let signinBackground = UIColor(named: "signinBackgroundColor")!
    static let placeholderGray = UIColor(named: "placeholderGrayColor")!
    static let firstBackground = UIColor(named: "firstBackgroundColor")!
    static let wrongTextField = UIColor(named: "wrongTextFieldColor")!
    
    /* V2 */
    case Primary
    case PrimarySecondary
    case TextPrimary
    case TextSecondary
    case TextSub1
    case BackgroundPrimary
    case BackgroundSecondary
    case BackgroundSub1
    case DividerPrimary
    case Gray70
    
    var value: UIColor { UIColor(named: self.rawValue) ?? .label }
}
