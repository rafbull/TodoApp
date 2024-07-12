//
//  TodoDetailViewModel.swift
//  ToDoApp
//
//  Created by Rafis on 28.06.2024.
//

import SwiftUI
import Combine

final class TodoDetailViewModel: ObservableObject {
    // MARK: - Internal Properties
    @Published var todoItem: TodoItem
    @Published var todoItemImportanceNumber: Int
    @Published var todoItemDeadline: Date
    @Published var todoItemHasDeadline: Bool
    @Published var todoItemHexColorValue: String
    @Published var todoItemColor: Color
    @Published var todoItemCategory: TodoItemCategory
    @Published var todoItemCategories = [TodoItemCategory]()
    
    // MARK: - Private Properties
    private let dataService: DataServiceProtocol
    private var subscriptions = Set<AnyCancellable>()
    
    // MARK: - Initialization
    init(todoItem: TodoItem?, dataService: DataServiceProtocol) {
        if let todoItem = todoItem {
            self.todoItem = todoItem
        } else {
            self.todoItem = TodoItem(
                text: "",
                importance: .unimportant,
                deadline: nil,
                isDone: false,
                modifyDate: .now,
                category: nil
            )
        }
        
        self.dataService = dataService
        
        todoItemImportanceNumber = TodoItem.Importance.allCases.firstIndex(of: todoItem?.importance ?? .normal) ?? 0
        todoItemDeadline = todoItem?.deadline ?? Date(timeIntervalSinceNow: 24 * 60 * 60)
        todoItemHasDeadline = todoItem?.deadline != nil
        todoItemHexColorValue = todoItem?.hexColor ?? "#FFFFFF"
        todoItemColor = Color.convertFromHex(todoItem?.hexColor ?? "#FFFFFF") ?? .white
        todoItemCategory = todoItem?.category ?? TodoItemCategory(
            name: AppConstant.TodoItemCategory.otherName,
            hexColor: AppConstant.TodoItemCategory.otherHexColor
        )
        
        getTodoItemCategories()
    }
    
    // MARK: - Internal Methods
    func updateItem(with text: String, modifyDate: Date?) {
        let importance = TodoItem.Importance.allCases[todoItemImportanceNumber]
        let updatedItem = TodoItem(
            id: todoItem.id,
            text: text,
            importance: importance,
            deadline: todoItemHasDeadline ? todoItemDeadline : nil,
            isDone: todoItem.isDone,
            creationDate: todoItem.creationDate,
            modifyDate: modifyDate,
            hexColor: todoItemHexColorValue,
            category: todoItemCategory
        )
        
        todoItem = updatedItem
        
        dataService.addNewOrUpdate(updatedItem)
    }
    
    func addNewTodoItemCategory(with name: String, and hexColor: String) {
        guard !name.isEmpty else { return }
        let newCategory = TodoItemCategory(name: name, hexColor: hexColor)
        dataService.addNewTodoItemCategory(newCategory)
    }
    
    func deleteTodoItem() {
        dataService.delete(todoItem)
    }
}

// MARK: - Private Extension
private extension TodoDetailViewModel {
    func getTodoItemCategories() {
        dataService.todoItemCategories
            .sink { [weak self] todoItemCategories in
                self?.todoItemCategories = todoItemCategories
            }
            .store(in: &subscriptions)
    }
}
