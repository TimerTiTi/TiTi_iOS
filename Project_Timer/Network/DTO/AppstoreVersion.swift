//
//  AppstoreVersion.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2022/05/21.
//  Copyright © 2022 FDEE. All rights reserved.
//

import Foundation

struct AppstoreVersion: Decodable {
    let resultCount: Int
    let results: [AppStoreVersionResult]
}

struct AppStoreVersionResult: Decodable {
    let version: String
}
