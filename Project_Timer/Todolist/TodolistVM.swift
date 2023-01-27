//
//  TodolistVM.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2022/04/01.
//  Copyright © 2022 FDEE. All rights reserved.
//

import Foundation

final class TodolistVM {
    private let fileName = "todolist.json"
    private var lastId: Int = 0
    private(set) var todolist: Todolist?
    private(set) var currentTodoGroup: String = "Untitled"
    private var todoGroupIndex: Int = 0
    private(set) var todos: [Todo] = []
    
    init() {
        self.loadTodolist()
    }
    
    private func loadTodolist() {
        self.todolist = Storage.retrive(self.fileName, from: .documents, as: Todolist.self) ?? nil
        
        guard self.todolist != nil else {
            self.createTodolist()
            return
        }
        
        self.currentTodoGroup = self.todolist?.currentGroupName ?? "Untitled"
        print(currentTodoGroup)
        self.todoGroupIndex = self.todolist?.todoGroups.firstIndex(where: { $0.groupName == self.currentTodoGroup }) ?? 0
        self.todos = self.todolist?.todoGroups[todoGroupIndex].todos ?? []
        self.lastId = todos.map(\.id).max() ?? 0
    }
    
    private func createTodolist() {
        self.todos = Storage.retrive("todos.json", from: .documents, as: [Todo].self) ?? []
        self.lastId = todos.map(\.id).max() ?? 0
        self.currentTodoGroup = "Untitled"
        self.todolist = Todolist(currentGroupName: "Untitled", todoGroups: [TodoGroup(groupName: "Untitled", todos: self.todos)])
        self.saveTodolist()
    }
    
    private func saveTodolist() {
        let todoGroup = TodoGroup(groupName: self.currentTodoGroup, todos: self.todos)
        self.todolist?.updateGroup(at: self.todoGroupIndex, to: todoGroup)
        self.todolist?.updateCurrentGroupName(to: self.currentTodoGroup)
        Storage.store(self.todolist, to: .documents, as: self.fileName)
    }
    
    func addNewTodo(text: String) {
        self.lastId += 1
        let newTodo = Todo(id: self.lastId, isDone: false, text: text)
        self.todos.append(newTodo)
        self.saveTodolist()
    }
    
    func deleteTodo(at index: Int) {
        let targetTodo = self.todos[index]
        self.todos.removeAll(where: { $0.id == targetTodo.id })
        self.saveTodolist()
    }
    
    func updateDone(at index: Int, to isDone: Bool) {
        self.todos[index].updateDone(to: isDone)
        self.saveTodolist()
    }
    
    func updateText(at index: Int, to text: String) {
        self.todos[index].updateText(to: text)
        self.saveTodolist()
    }
    
    func moveTodo(fromIndex: Int, toIndex: Int) {
        var todos = self.todos
        let targetTodo = todos.remove(at: fromIndex)
        todos.insert(targetTodo, at: toIndex)
        self.todos = todos
        self.saveTodolist()
    }
    
    func updateTodoGroupName(to todoGroupName: String) {
        self.currentTodoGroup = todoGroupName
        self.saveTodolist()
    }
    
    func changeTodoGroup(to todoGroupName: String) {
        self.currentTodoGroup = todoGroupName
        self.todoGroupIndex = self.todolist?.todoGroups.firstIndex(where: { $0.groupName == self.currentTodoGroup }) ?? 0
        self.todos = self.todolist?.todoGroups[todoGroupIndex].todos ?? []
        self.lastId = todos.map(\.id).max() ?? 0
        self.saveTodolist()
    }
    
    func addNewTodoGroup(_ todoGroup: String) {
        self.currentTodoGroup = todoGroup
        self.lastId = 0
        self.todos = []
        let group = TodoGroup(groupName: todoGroup, todos: [])
        self.todolist?.addGroup(todoGroup: group)
        Storage.store(self.todolist, to: .documents, as: self.fileName)
    }
}
