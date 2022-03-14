//
//  Manager.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2021/06/17.
//  Copyright © 2021 FDEE. All rights reserved.
//

import UIKit

struct Converter {
    static func translate(input: String) -> String {
        if(input == "NO DATA") {
            return "-/-"
        } else {
            print(input)
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "M월 d일"
            let exported = dateFormatter.date(from: input)!
            let newDateFormatter = DateFormatter()
            newDateFormatter.dateFormat = "M/d"
            return newDateFormatter.string(from: exported)
        }
    }
    
    static func translate2(input: String) -> Int {
        if(input == "NO DATA") {
            return 0
        } else {
            var sum: Int = 0
            print(input)
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "HH:mm:ss"
            let exported = dateFormatter.date(from: input)!
            
            sum += Calendar.current.component(.hour, from: exported)*3600
            sum += Calendar.current.component(.minute, from: exported)*60
            sum += Calendar.current.component(.second, from: exported)
            return sum
        }
    }
}
