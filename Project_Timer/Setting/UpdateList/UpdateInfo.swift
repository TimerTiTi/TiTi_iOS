//
//  UpdateInfo.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2022/06/04.
//  Copyright © 2022 FDEE. All rights reserved.
//

import Foundation

struct UpdateInfo {
    let version: String
    let date: String
    let text: String
    
    init(data: [String: Any]) {
        self.version = data["version"] as? String ?? "version error"
        self.date = data["date"] as? String ?? "date error"
        let temp = data["text"] as? String ?? "text error"
        self.text = temp.replacingOccurrences(of: "\\n", with: "\n")
    }
}
