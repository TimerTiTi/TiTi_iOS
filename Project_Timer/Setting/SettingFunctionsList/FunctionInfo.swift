//
//  FunctionInfo.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2022/06/05.
//  Copyright © 2022 FDEE. All rights reserved.
//

import Foundation

struct FunctionInfo: Codable {
    let title: String
    let url: String
    
    init(data: [String: Any]) {
        self.title = data["title"] as? String ?? "title error"
        self.url = data["url"] as? String ?? "url error"
    }
}

protocol FunctionsActionDelegate: AnyObject {
    func showWebview(url: String)
}
