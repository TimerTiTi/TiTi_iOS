//
//  Todolist.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2023/01/27.
//  Copyright © 2023 FDEE. All rights reserved.
//

import Foundation

struct Todolist: Codable {
    var currentGroupName: String
    var todoGroups: [TodoGroup]
}

struct TodoGroup: Codable {
    var groupName: String
    var todos: [Todo]
    
    mutating func updateGroupName(to groupName: String) {
        self.groupName = groupName
    }
}
