//
//  todolistViewModel.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2021/06/09.
//  Copyright © 2021 FDEE. All rights reserved.
//

import UIKit

class TodolistViewModel {
    
    private let manager = TodoManager.shared
    
    var todos: [Todo] {
        return manager.todos
    }
    
    func addTodo(_ todo: Todo) {
        manager.addTodo(todo)
    }
    
    func deleteTodo(_ todo: Todo) {
        manager.deleteTodo(todo)
    }
    
    func updateTodo(_ todo: Todo) {
        manager.updateTodo(todo)
    }
    
    func loadTodos() {
        manager.loadTodos()
    }
}
