//
//  UIColor+Extension.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2022/07/17.
//  Copyright © 2022 FDEE. All rights reserved.
//

import UIKit

extension UIColor {
    static func graphColor(num: Int) -> UIColor {
        return UIColor(named: "D\(num)") ?? .blue
    }
}
