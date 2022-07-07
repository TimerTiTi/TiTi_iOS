//
//  Language.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2022/07/07.
//  Copyright © 2022 FDEE. All rights reserved.
//

import Foundation

enum Language: String {
    case ko
    case en
    
    static var currentLanguage: Language {
        return Language(rawValue: Locale.current.languageCode ?? "en") ?? .en
    }
}
