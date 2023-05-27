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
    static let instagramToFDEE: String = "https://www.instagram.com/dev_fdee/"
    static let github: String = "https://github.com/FreeDeveloper97"
    
    enum Firestore {
        static let projectId: String = "titi-b8650"
        static let domain: String = "https://firestore.googleapis.com/v1/projects/\(projectId)/databases/(default)/documents"
        static let links: String = domain + "/links"
        static let youtubeLink: String = links + "/youtube"
        static let surveys: String = domain + "/surveys"
        static let lastestVersion: String = domain + "/version/lastestVersion"
        
        static var titifuncs: String {
            switch Language.currentLanguage {
            case .ko: return domain + "/titifuncs"
            case .en: return domain + "/titifuncs_eng"
            }
        }
        
        static var updates: String {
            switch Language.currentLanguage {
            case .ko: return domain + "/updates?pageSize=100"
            case .en: return domain + "/updates_eng?pageSize=100"
            }
        }
    }
    
    enum TestServer {
        static let base: String = Bundle.main.infoDictionary?["TestServerURL"] as? String ?? ""
        static let auth: String = base+"/auth"
        static let dailys: String = base+"/dailys"
        static let timelines: String = base+"/timelines"
        static let tasks: String = base+"/tasks"
        static let syncLog: String = base+"/syncLog"
        static let recordTime: String = base+"/recordTime"
        // auth
        static let authSignup: String = auth+"/signup"
        static let authLogin: String = auth+"/login"
        // dailys
        static let dailysUpload: String = dailys+"/upload"
    }
    
    enum Useage {
        static var todolist: String {
            switch Language.currentLanguage {
            case .ko: return "https://deeply-eggplant-5ec.notion.site/Todolist-ff23ffb5e6634955b11e1202b95d17fc"
            case .en: return "https://deeply-eggplant-5ec.notion.site/Todolist-0b68ee031a414cf8896c8f6b9a9b3ebe"
            }
        }
        
        static var timer: String {
            switch Language.currentLanguage {
            case .ko: return "https://deeply-eggplant-5ec.notion.site/Timer-1db945227c25409d874bf82e30a0523a"
            case .en: return "https://deeply-eggplant-5ec.notion.site/Timer-5b82d114ed3d4981a5d077daa147f53f"
            }
        }
        
        static var stopwatch: String {
            switch Language.currentLanguage {
            case .ko: return "https://deeply-eggplant-5ec.notion.site/Stopwatch-f89204f11e5d468794899d35a18b084f"
            case .en: return "https://deeply-eggplant-5ec.notion.site/Stopwatch-0fffbd65974a4fa0a0c19a9f41d41a6f"
            }
        }
    }
    
    enum WidgetInfo {
        static var calendarWidget: String {
            switch Language.currentLanguage {
            case .ko: return "https://timertiti.notion.site/772f0dd247be4a628dcd09779186e252"
            case .en: return "https://timertiti.notion.site/Calendar-Widget-b5b33a9af1714058a6a41d612652c0de"
            }
        }
    }
}
