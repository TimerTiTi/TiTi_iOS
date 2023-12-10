//
//  NetworkURL.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2022/05/21.
//  Copyright © 2022 FDEE. All rights reserved.
//

import Foundation
import SwiftUI

enum NetworkURL {
    static let appstoreVersion: String = "https://itunes.apple.com/lookup?id=1519159240&country=kr"
    static let appstore: String = "itms-apps://itunes.apple.com/app/id1519159240"
    static let developmentList: String = "https://deeply-eggplant-5ec.notion.site/TiTi-Development-List-b089afc1a4eb4cdb8c06840ca9cb1273"
    static let instagramToTiTi: String = "https://www.instagram.com/study_withtiti/"
    static let instagramToDeveloper: String = "https://www.instagram.com/dev_mindsang/"
    static let github: String = "https://github.com/TimerTiTi"
    
    enum Firestore {
        static let domain: String = Infos.FirestoreURL.value
        static let links: String = domain + "/links"
        static let youtubeLink: String = links + "/youtube"
        static var latestVersion: String {
            #if targetEnvironment(macCatalyst)
            return domain + "/version/macos"
            #else
            return domain + "version/ios"
            #endif
        }
        
        static var surveys: String {
            switch Language.system {
            case .ko: return domain + "/surveys"
            default: return domain + "/surveys_eng"
            }
        }
        
        static var titifuncs: String {
            switch Language.system {
            case .ko: return domain + "/titifuncs"
            default: return domain + "/titifuncs_eng"
            }
        }
        
        static var updates: String {
            switch Language.system {
            case .ko: return domain + "/updates?pageSize=100"
            default: return domain + "/updates_eng?pageSize=100"
            }
        }
    }
    
    enum TestServer {
        static let base: String = Infos.ServerURL.value
        static let auth: String = base+"/auth"
        static let dailys: String = base+"/dailys"
        static let timelines: String = base+"/timelines"
        static let tasks: String = base+"/tasks"
        static let syncLog: String = base+"/syncLog"
        static let recordTime: String = base+"/recordTime"
        // auth
        static let authSignup: String = auth+"/signup"
        static let authSignin: String = auth+"/login"
        // dailys
        static let dailysUpload: String = dailys+"/upload"
    }
    
    enum Useage {
        static var todolist: String {
            switch Language.system {
            case .ko: return "https://deeply-eggplant-5ec.notion.site/Todolist-ff23ffb5e6634955b11e1202b95d17fc"
            default: return "https://deeply-eggplant-5ec.notion.site/Todolist-0b68ee031a414cf8896c8f6b9a9b3ebe"
            }
        }
        
        static var timer: String {
            switch Language.system {
            case .ko: return "https://deeply-eggplant-5ec.notion.site/Timer-1db945227c25409d874bf82e30a0523a"
            default: return "https://deeply-eggplant-5ec.notion.site/Timer-5b82d114ed3d4981a5d077daa147f53f"
            }
        }
        
        static var stopwatch: String {
            switch Language.system {
            case .ko: return "https://deeply-eggplant-5ec.notion.site/Stopwatch-f89204f11e5d468794899d35a18b084f"
            default: return "https://deeply-eggplant-5ec.notion.site/Stopwatch-0fffbd65974a4fa0a0c19a9f41d41a6f"
            }
        }
    }
    
    enum WidgetInfo {
        static var calendarWidget: String {
            switch Language.system {
            case .ko: return "https://titicalendarwidgetkor.simple.ink/"
            default: return "https://titicalendarwidgeteng.simple.ink/"
            }
        }
    }
}
