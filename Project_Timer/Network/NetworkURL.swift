//
//  NetworkURL.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2022/05/21.
//  Copyright © 2022 FDEE. All rights reserved.
//

import Foundation

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
        static let titifuncs: String = domain + "/titifuncs"
        static let updates: String = domain + "/updates"
        static let surveys: String = domain + "/surveys"
    }
}
