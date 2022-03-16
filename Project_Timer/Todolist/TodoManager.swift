//
//  TodoManager.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2021/06/29.
//  Copyright © 2021 FDEE. All rights reserved.
//

import Foundation

class TodoManager {
    static let shared = TodoManager()
    static var lastId: Int = 0
    var todos: [Todo] = []
    
    func createTodo(text: String) -> Todo {
        let nextId = TodoManager.lastId + 1
        TodoManager.lastId = nextId
        return Todo(id: nextId, isDone: false, text: text)
    }
    
    func addTodo(_ todo: Todo) {
        todos.append(todo)
        saveTodo()
    }
    
    func deleteTodo(_ todo: Todo) {
        todos = todos.filter { $0.id != todo.id }
        saveTodo()
    }
    
    func updateTodo(_ todo: Todo) {
        guard let index = todos.firstIndex(of: todo) else { return }
        todos[index].update(isDone: todo.isDone, text: todo.text)
        saveTodo()
    }
    
    func saveTodo() {
        print("save: \(todos.map(\.text))")
        Storage.store(todos, to: .documents, as: "todos.json")
    }
    
    func loadTodos() {
        todos = Storage.retrive("todos.json", from: .documents, as: [Todo].self) ?? []
        let lastId = todos.last?.id ?? 0
        TodoManager.lastId = lastId
    }
}
