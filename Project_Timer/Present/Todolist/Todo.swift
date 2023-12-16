//
//  Todo.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2021/06/11.
//  Copyright © 2021 FDEE. All rights reserved.
//

import Foundation

struct Todo: Codable, Equatable {
    let id: Int
    var isDone: Bool
    var text: String
    
    mutating func updateDone(to isDone: Bool) {
        self.isDone = isDone
    }
    
    mutating func updateText(to text: String) {
        self.text = text
    }
    
    static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.id == rhs.id
    }
}
