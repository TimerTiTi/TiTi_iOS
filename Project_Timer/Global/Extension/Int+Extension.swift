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
        let time = self < 0 ? -self : self
        let s = time % 60
        let h = time / 3600
        let m = (time / 60) - (h * 60)
        
        if self < 0 {
            return String(format: "+%d:%02d:%02d", h, m, s)
        } else {
            return String(format: "%d:%02d:%02d", h, m, s)
        }
    }
    
    var toHM: String {
        let h = self / 3600
        let m = (self / 60) - (h * 60)
        return String(format: "%d:%02d", h, m)
    }
}
