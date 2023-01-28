//
//  TodolistVM.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2022/04/01.
//  Copyright © 2022 FDEE. All rights reserved.
//

import Foundation
import Combine

final class TodolistVM {
    private let defaultGroup: String = "Untitled"
    private let fileName = "todolist.json"
    @Published private(set) var currentGroupName: String = ""
    private(set) var groups: [TodoGroup] = []
    private(set) var todos: [Todo] = []
    private(set) var groupIndex: Int = 0
    
    private var lastId: Int = 0
    
    init() {
        self.loadTodolist()
    }
    
    private func loadTodolist() {
        guard let todolist = Storage.retrive(self.fileName, from: .documents, as: Todolist.self) else {
            self.createTodolist()
            return
        }
        
        self.groups = todolist.todoGroups
        self.groupIndex = todolist.todoGroups.firstIndex(where: { $0.groupName == todolist.currentGroupName }) ?? 0
        self.todos = todolist.todoGroups[self.groupIndex].todos
        self.lastId = todos.map(\.id).max() ?? 0
        self.currentGroupName = todolist.currentGroupName
    }
    
    private func createTodolist() {
        self.todos = Storage.retrive("todos.json", from: .documents, as: [Todo].self) ?? []
        self.lastId = todos.map(\.id).max() ?? 0
        self.groups = [TodoGroup(groupName: self.defaultGroup, todos: self.todos)]
        self.currentGroupName = self.defaultGroup
        self.saveTodolist()
    }
    
    private func saveTodolist() {
        // currentGroupName, todos -> todoGroup 생성, todolist 생성 후 저장
        let currentGroup = TodoGroup(groupName: self.currentGroupName, todos: self.todos)
        self.groups[self.groupIndex] = currentGroup
        let todolist = Todolist(currentGroupName: self.currentGroupName, todoGroups: self.groups)
        Storage.store(todolist, to: .documents, as: self.fileName)
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
    
    func updateTodoGroupName(to groupName: String) -> Bool {
        let groups = self.groups.map(\.groupName)
        guard groups.contains(groupName) == false else { return false }
        
        self.groups[self.groupIndex].updateGroupName(to: groupName)
        self.currentGroupName = groupName
        self.saveTodolist()
        return true
    }
    
    func changeTodoGroup(to groupName: String) {
        self.groupIndex = self.groups.firstIndex(where: { $0.groupName == groupName }) ?? 0
        self.todos = self.groups[self.groupIndex].todos
        self.lastId = todos.map(\.id).max() ?? 0
        self.currentGroupName = groupName
    }
    
    func addNewTodoGroup(_ groupName: String) -> Bool {
        let groups = self.groups.map(\.groupName)
        guard groups.contains(groupName) == false else { return false }
        
        self.groups.append(TodoGroup(groupName: groupName, todos: []))
        self.groupIndex = self.groups.count-1
        self.todos = []
        self.lastId = 0
        self.currentGroupName = groupName
        return true
    }
    
    func deleteTodoGroup() {
        self.groups = self.groups.filter { $0.groupName != self.currentGroupName }
        if self.groups.isEmpty {
            self.groups = [TodoGroup(groupName: self.defaultGroup, todos: [])]
            self.todos = []
            self.lastId = 0
            self.currentGroupName = self.defaultGroup
            self.saveTodolist()
        } else {
            if self.groups.count == self.groupIndex {
                self.groupIndex -= 1
            }
            self.todos = self.groups[self.groupIndex].todos
            self.lastId = todos.map(\.id).max() ?? 0
            self.currentGroupName = self.groups[self.groupIndex].groupName
            self.saveTodolist()
        }
    }
}
