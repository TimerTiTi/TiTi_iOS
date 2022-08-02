//
//  Logs.swift
//  Project_Timer
//
//  Created by 최수정 on 2022/08/02.
//  Copyright © 2022 FDEE. All rights reserved.
//

import Foundation

struct Log: Codable {
    static let fileName = "logs.json"
    
    let totalTimeOfMonth: Int
    let totalTimeOfWeek: Int
}
