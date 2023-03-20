//
//  RoundedShape.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2023/03/20.
//  Copyright © 2023 FDEE. All rights reserved.
//

import Foundation
import SwiftUI

struct RoundedShape: Shape {
    let radius: CGFloat
    init(radius: CGFloat = 5) {
        self.radius = radius
    }
    
    func path(in rect : CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: [.topLeft,.topRight], cornerRadii: CGSize(width: self.radius, height: self.radius))
        return Path(path.cgPath)
    }
}
