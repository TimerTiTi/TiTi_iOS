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
        case D4
        case D5
        case D6
        case D7
        case D8
        case D9
        case D10
        case D11
        case D12
    }
    
    let color: Color
    let url: URL = URL(string: "/Log")!
    let now: Date
    
    init(color: Color) {
        self.color = color
        self.now = Calendar.current.date(byAdding: .month, value: 2, to: Date())!
    }
    
    init(color: Color, now: Date) {
        self.color = color
        self.now = Calendar.current.date(byAdding: .month, value: 2, to: now)!
    }
}
