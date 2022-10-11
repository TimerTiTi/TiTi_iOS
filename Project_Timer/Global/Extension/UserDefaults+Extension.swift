//
//  UserDefaults+Extension.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2022/07/03.
//  Copyright © 2022 FDEE. All rights reserved.
//

import UIKit

extension UserDefaults {
    enum Keys: String {
        case timerBackground
        case stopwatchBackground
        case color // 레거시 값
    }
    
    func colorForKey(key: Keys) -> UIColor? {
        var color: UIColor?
        if let colorData = data(forKey: key.rawValue) {
            color = NSKeyedUnarchiver.unarchiveObject(with: colorData) as? UIColor
        }
        return color
    }
    
    func setColor(color: UIColor?, forKey key: Keys) {
        var colorData: NSData?
        if let color = color {
            colorData = NSKeyedArchiver.archivedData(withRootObject: color) as NSData?
        }
        set(colorData, forKey: key.rawValue)
    }
}
