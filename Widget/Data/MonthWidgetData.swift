//
//  MonthWidgetData.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2023/05/12.
//  Copyright © 2023 FDEE. All rights reserved.
//

import Foundation

struct MonthWidgetData {
    enum Color: Int {
        case D1 = 1
        case D2
        case D3
    }
    
    let color: Color
    let url: URL = URL(string: "/Log")!
    let now: Date
    
    init(color: Color) {
        self.color = color
        self.now = Date()
    }
    
    init(color: Color, now: Date) {
        self.color = color
        self.now = now
    }
}
