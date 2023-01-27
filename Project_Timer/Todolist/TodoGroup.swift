//
//  TodoGroup.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2023/01/27.
//  Copyright © 2023 FDEE. All rights reserved.
//

import Foundation

struct TodoGroup: Codable, Equatable {
    var groupName: String
    var todos: [Todo]
    
    mutating func updateGroupName(to groupName: String) {
        self.groupName = groupName
    }
    
    mutating func updateTodos(to todos: [Todo]) {
        self.todos = todos
    }
    
    static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.groupName == rhs.groupName
    }
}
