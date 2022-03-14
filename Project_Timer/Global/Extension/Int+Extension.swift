//
//  Int+Extension.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2022/03/14.
//  Copyright © 2022 FDEE. All rights reserved.
//

import Foundation

extension Int {
    var toTimeString: String {
        let s = self % 60
        let h = self / 3600
        let m = (self / 60) - (h * 60)
        return String(format: "%d:%02d:%02d", h, m, s)
    }
}
