//
//  NetworkURL.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2022/05/21.
//  Copyright © 2022 FDEE. All rights reserved.
//

import Foundation
import SwiftUI

class NetworkURL {
    static let shared = NetworkURL()
    private(set) var serverURL: String?
    
    private init() {
        self.updateServerURL() {}
    }
    
    func updateServerURL(completion: @escaping () -> Void) {
        let getServerURLUseCase = GetServerURLUseCase(repository: ServerURLRepository())
        getServerURLUseCase.getServerURL { [weak self] result in
            switch result {
            case .success(let url):
                guard url != "nil" else {
                    self?.serverURL = nil
                    completion()
                    return
                }
                
                self?.serverURL = url
                completion()
            case .failure(_):
                self?.serverURL = nil
                completion()
            }
        }
    }
    
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
            switch Language.current {
            case .ko: return domain + "/surveys"
            default: return domain + "/surveys_eng"
            }
        }
        
        static var titifuncs: String {
            switch Language.current {
            case .ko: return domain + "/titifuncs"
            default: return domain + "/titifuncs_eng"
            }
        }
        
        static var updates: String {
            switch Language.current {
            case .ko: return domain + "/updates?pageSize=100"
            default: return domain + "/updates_eng?pageSize=100"
            }
        }
    }
    
    enum WidgetInfo {
        static var calendarWidget: String {
            switch Language.current {
            case .ko: return "https://titicalendarwidgetkor.simple.ink/"
            default: return "https://titicalendarwidgeteng.simple.ink/"
            }
        }
    }
}
