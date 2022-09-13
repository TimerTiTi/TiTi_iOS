//
//  DayOfWeekText.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2022/09/13.
//  Copyright © 2022 FDEE. All rights reserved.
//

import SwiftUI

struct DayOfWeekText: View {
    let today: Date
    let days = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]
    let dayIndex: Int
    let colorIndex: Int
    
    init(today: Date, dayIndex: Int, colorIndex: Int) {
        self.today = today
        self.dayIndex = dayIndex
        self.colorIndex = colorIndex
    }
    
    var body: some View {
        Text(self.days[dayIndex])
            .font(TiTiFont.HGGGothicssiP60g(size: 13))
            .foregroundColor(.primary)
            .frame(width: 25, height: 15)
            .background(backgroundColor)
    }
    
    var isToday: Bool {
        return today.indexDayOfWeek == dayIndex
    }
    
    var backgroundColor: Color {
        if isToday {
            return UIColor(named: "D\(colorIndex)")?.withAlphaComponent(0.5).toColor ?? .clear
        } else {
            return .clear
        }
    }
}
