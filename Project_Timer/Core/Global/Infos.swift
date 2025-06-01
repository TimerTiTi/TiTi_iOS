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
    case ServerURL_devminsang2
    case FirestoreURL
    case APP_BUNDLE_ID
    case ADMOB_AD_ID
    
    var value: String {
        switch self {
        case .ADMOB_AD_ID:
            #if DEBUG
            return "ca-app-pub-3940256099942544/1712485313"
            #else
            return Bundle.main.infoDictionary?[self.rawValue] as? String ?? ""
            #endif
        default:
            return Bundle.main.infoDictionary?[self.rawValue] as? String ?? ""
        }
    }
    
    static var isDevMode: Bool {
        return Infos.MODE.value == "dev"
    }
}
