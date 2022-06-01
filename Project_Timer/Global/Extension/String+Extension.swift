//
//  String+Extension.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2022/05/21.
//  Copyright © 2022 FDEE. All rights reserved.
//

import Foundation

extension String {
    static let currentVersion: String = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
    static var userTintColor: String {
        let colorIndex = UserDefaults.standard.value(forKey: "startColor") as? Int ?? 1
        return "D\(colorIndex)"
    }
}
