//
//  DataService.swift
//  ToDoApp
//
//  Created by Rafis on 28.06.2024.
//

import Foundation
import Combine
import CocoaLumberjackSwift

protocol DataServiceProtocol {
    var todoItems: CurrentValueSubject <[TodoItem], Never> { get }
    var todoItemCategories: CurrentValueSubject <[TodoItemCategory], Never> { get }
    
    func addNewOrUpdate(_ todoItem: TodoItem)
    func delete(_ todoItem: TodoItem)
    
    func addNewTodoItemCategory(_ category: TodoItemCategory)
}

final class DataService: DataServiceProtocol {
    // MARK: - Private Properties
    private(set) var todoItems = CurrentValueSubject <[TodoItem], Never>([])
    private(set) var todoItemCategories = CurrentValueSubject <[TodoItemCategory], Never>([])
    
    // MARK: - Initialization
    init() {
        createMockData()
        createTodoItemCategories()
    }
    
    // MARK: - Internal Methods
    func addNewOrUpdate(_ todoItem: TodoItem) {
        if let index = todoItems.value.firstIndex(where: { $0.id == todoItem.id }) {
            todoItems.value[index] = todoItem
            DDLogInfo("File: \(#fileID) Function: \(#function)\n\tUpdate TodoItem with id:\(todoItem.id).")
        } else {
            todoItems.value.append(todoItem)
            DDLogInfo("File: \(#fileID) Function: \(#function)\n\tAdd new TodoItem with id:\(todoItem.id).")
        }
    }
    
    func delete(_ todoItem: TodoItem) {
        guard let index = todoItems.value.firstIndex(where: { $0.id == todoItem.id }) else {
            DDLogWarn("File: \(#fileID) Function: \(#function)\n\tTodoItem with id:\(todoItem.id) is not found!")
            return
        }
        todoItems.value.remove(at: index)
        DDLogInfo("File: \(#fileID) Function: \(#function)\n\tDelete TodoItem with id:\(todoItem.id).")
    }
    
    func addNewTodoItemCategory(_ category: TodoItemCategory) {
        if todoItemCategories.value.count > 1 {
            todoItemCategories.value.insert(category, at: todoItemCategories.value.count - 1)
        } else {
            todoItemCategories.value.append(category)
        }
        DDLogInfo("File: \(#fileID) Function: \(#function)\n\tAdd new Category with id:\(category.id).")
    }
}

// MARK: - Private Extension
private extension DataService {
    func createMockData() {
        todoItems.send([
            .init(
                text: "1_Купить что-то, где-то, зачем-то, но зачем не очень понятно, Купить что-то, где-то, зачем-то, но зачем не очень понятно",
                importance: .important,
                deadline: .now + 48 * 60 * 60,
                isDone: false,
                modifyDate: nil,
                category: .init(
                    name: AppConstant.TodoItemCategory.workName,
                    hexColor: AppConstant.TodoItemCategory.workHexColor
                )
            ),
            .init(
                text: "2_Second",
                importance: .normal,
                deadline: .now + 48 * 60 * 60,
                isDone: true,
                modifyDate: nil,
                category: .init(
                    name: AppConstant.TodoItemCategory.hobbyName,
                    hexColor: AppConstant.TodoItemCategory.hobbyHexColor
                )
            ),
            .init(
                text: "3_Купить что-то, где-то, зачем-то, но зачем не очень понятно, Купить что-то, где-то, зачем-то, но зачем не очень понятно",
                importance: .unimportant,
                deadline: nil,
                isDone: false,
                modifyDate: nil,
                category: .init(
                    name: AppConstant.TodoItemCategory.studyName,
                    hexColor: AppConstant.TodoItemCategory.studyHexColor
                )
            )
        ])
        
        (1...10).forEach { index in
            let newTodoItem = TodoItem(
                text: "New \(index)_Купить что-то",
                importance: .unimportant,
                deadline: .now + (48 * 60 * 60 * TimeInterval(index)),
                isDone: false,
                modifyDate: nil,
                category: nil
            )
            todoItems.value.append(newTodoItem)
        }
    }
    
    func createTodoItemCategories() {
        todoItemCategories.send([
            .init(name: AppConstant.TodoItemCategory.workName, hexColor: AppConstant.TodoItemCategory.workHexColor),
            .init(name: AppConstant.TodoItemCategory.studyName, hexColor: AppConstant.TodoItemCategory.studyHexColor),
            .init(name: AppConstant.TodoItemCategory.hobbyName, hexColor: AppConstant.TodoItemCategory.hobbyHexColor),
            .init(name: AppConstant.TodoItemCategory.otherName, hexColor: AppConstant.TodoItemCategory.otherHexColor)
        ])
    }
}
