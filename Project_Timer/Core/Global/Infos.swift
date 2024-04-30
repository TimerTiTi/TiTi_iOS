//
//  Infos.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2023/09/25.
//  Copyright © 2023 FDEE. All rights reserved.
//

import Foundation

enum Infos: String {
    case MODE
    case ServerURL
    case ServerURL2
    case FirestoreURL
    case APP_BUNDLE_ID
    case ADMOB_AD_ID
    
    var value: String {
        return Bundle.main.infoDictionary?[self.rawValue] as? String ?? ""
    }
    
    static var isDevMode: Bool {
        return Infos.MODE.value == "dev"
    }
}
