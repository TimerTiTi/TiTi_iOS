//
//  Color+Extension.swift
//  Project_Timer
//
//  Created by 최수정 on 2022/07/01.
//  Copyright © 2022 FDEE. All rights reserved.
//

import SwiftUI

extension Color {
    public static var stopWatchColor: Color {
        if let userColor = UserDefaults.colorForKey(key: .stopwatchBackground) {
            return Color(userColor)
        } else if let userColor = UserDefaults.colorForKey(key: .color) {
            return Color(userColor)
        } else {
            return Color(TiTiColor.stopwatchBackground ?? .clear)
        }
    }
    
    public static var timerColor: Color {
        if let userColor = UserDefaults.colorForKey(key: .timerBackground) {
            return Color(userColor)
        } else {
            return Color(TiTiColor.timerBackground ?? .clear)
        }
    }
}
