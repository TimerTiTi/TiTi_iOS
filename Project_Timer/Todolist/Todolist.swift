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
    
    mutating func updateCurrentGroupName(to groupName: String) {
        self.currentGroupName = groupName
    }
    
    mutating func updateGroup(at index: Int, to todoGroup: TodoGroup) {
        self.todoGroups[index] = todoGroup
    }
    
    mutating func addGroup(todoGroup: TodoGroup) {
        self.todoGroups.append(todoGroup)
        self.currentGroupName = todoGroup.groupName
    }
}
