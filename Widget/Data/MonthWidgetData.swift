//
//  MonthWidgetData.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2023/05/12.
//  Copyright © 2023 FDEE. All rights reserved.
//

import Foundation

struct MonthWidgetData {
    enum Color: String {
        case D1
        case D2
        case D3
    }
    
    let color: Color
    let url: URL = URL(string: "/Log")!
}
