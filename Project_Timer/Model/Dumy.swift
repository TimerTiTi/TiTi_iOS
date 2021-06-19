//
//  Dumy.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2021/06/19.
//  Copyright © 2021 FDEE. All rights reserved.
//

import Foundation
struct Dumy {
    func getTasks() -> [String:Int] {
        var dumy: [String:Int] = [:]
        dumy.updateValue(2000, forKey: "Swift")
        dumy.updateValue(3000, forKey: "Java")
        dumy.updateValue(1200, forKey: "C++")
        dumy.updateValue(2400, forKey: "Python")
        dumy.updateValue(2800, forKey: "Algorithm")
        dumy.updateValue(3200, forKey: "Programming")
        dumy.updateValue(1000, forKey: "coding")
        dumy.updateValue(800, forKey: "blog")
        dumy.updateValue(2200, forKey: "design")
        dumy.updateValue(2500, forKey: "develop")
        dumy.updateValue(2600, forKey: "typing")
        dumy.updateValue(3600, forKey: "TiTi develop")
        return dumy
    }
    
    func getTimelines() -> [Int] {
        let timeline = [3600,1300,0,0,0,0,0,0,0,1200,2000,3000,2600,2600,3600,3600,1000,0,500,2000,0,0,0,1200]
        return timeline
    }
}
