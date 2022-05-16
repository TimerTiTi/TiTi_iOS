//
//  daily.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2022/05/16.
//  Copyright © 2022 FDEE. All rights reserved.
//

import Foundation

struct daily: Hashable {
    let day: String
    let studyTime: Int
    
    init(day: String, studyTime: Int) {
        self.day = day
        self.studyTime = studyTime
    }
    
    init(_ Daily: Daily) {
        self.day = Daily.day.MDstyleString
        self.studyTime = Daily.totalTime
    }
    
    init() {
        self.day = "-/-"
        self.studyTime = 0
    }
}
