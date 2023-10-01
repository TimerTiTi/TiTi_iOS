//
//  CGPoint+Extension.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2023/10/01.
//  Copyright © 2023 FDEE. All rights reserved.
//

import Foundation

extension CGPoint {
    static func +(lhs: Self, rhs: Self) -> CGPoint {
        return CGPoint(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
    }
}
