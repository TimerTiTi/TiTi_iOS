//
//  TodolistVM.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2022/04/01.
//  Copyright © 2022 FDEE. All rights reserved.
//

import Foundation

final class TodolistVM {
    private let fileName = "todos.json"
    private var lastId: Int = 0
    private(set) var todos: [Todo] = []
    
    init() {
        self.loadTodos()
    }
    
    private func loadTodos() {
        self.todos = Storage.retrive(self.fileName, from: .documents, as: [Todo].self) ?? []
        self.lastId = todos.map(\.id).max() ?? 0
    }
    
    private func saveTodos() {
        Storage.store(self.todos, to: .documents, as: self.fileName)
    }
    
    func addNewTodo(text: String) {
        self.lastId += 1
        let newTodo = Todo(id: self.lastId, isDone: false, text: text)
        self.todos.append(newTodo)
        self.saveTodos()
    }
    
    func deleteTodo(at index: Int) {
        let targetTodo = self.todos[index]
        self.todos.removeAll(where: { $0.id == targetTodo.id })
        self.saveTodos()
    }
    
    func updateDone(at index: Int, to isDone: Bool) {
        self.todos[index].updateDone(to: isDone)
        self.saveTodos()
    }
    
    func updateText(at index: Int, to text: String) {
        self.todos[index].updateText(to: text)
        self.saveTodos()
    }
    
    func moveTodo(fromIndex: Int, toIndex: Int) {
        var todos = self.todos
        let targetTodo = todos.remove(at: fromIndex)
        todos.insert(targetTodo, at: toIndex)
        self.todos = todos
        self.saveTodos()
    }
}
