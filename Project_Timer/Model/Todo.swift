//
//  Todo.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2021/06/11.
//  Copyright © 2021 FDEE. All rights reserved.
//

import UIKit

struct Todo: Codable, Equatable {
    let id: Int
    var isDone: Bool
    var text: String
    
    mutating func update(isDone: Bool, text: String) {
        self.isDone = isDone
        self.text = text
    }
    
    static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.id == rhs.id
    }
}
