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
        if #available(iOS 16.0, *) {
            guard let locale = Locale.preferredLanguages.first,
                  let languageCode = Locale(identifier: locale).language.languageCode?.identifier else {
                return .en
            }
            
            return Language(rawValue: languageCode) ?? .en
        } else {
            guard let locale = Locale.preferredLanguages.first,
                  let languageCode = Locale(identifier: locale).languageCode else {
                return .en
            }
            
            return Language(rawValue: languageCode) ?? .en
        }
        
    }
}

extension Bundle {
    static var koBundle: Bundle {
        guard let koPath = Bundle.main.path(forResource: "ko", ofType: "lproj"),
              let koBundle = Bundle(path: koPath) else {
            print("Error: Bundle of \"ko\" can't access")
            return Bundle.main
        }
        
        return koBundle
    }
    
    static var enBundle: Bundle {
        guard let enPath = Bundle.main.path(forResource: "en", ofType: "lproj"),
              let enBundle = Bundle(path: enPath) else {
            print("Error: Bundle of \"en\" can't access")
            return Bundle.main
        }
        
        return enBundle
    }
    
    static var localizedBundle: Bundle {
        switch Language.currentLanguage {
        case .ko:
            return Bundle.koBundle
        case .en:
            return Bundle.enBundle
        }
    }
}
