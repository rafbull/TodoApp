//
//  TodoDetailViewModel.swift
//  ToDoApp
//
//  Created by Rafis on 28.06.2024.
//

import SwiftUI

final class TodoDetailViewModel: ObservableObject {
    // MARK: - Internal Properties
    @Published var todoItem: TodoItem
    @Published var todoItemImportanceNumber: Int
    @Published var todoItemDeadline: Date
    @Published var todoItemHasDeadline: Bool
    @Published var todoItemHexColorValue: String
    @Published var todoItemColor: Color
    
    // MARK: - Private Properties
    private let dataService: DataServiceProtocol
    
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
                modifyDate: .now
            )
        }
        
        self.dataService = dataService
        
        todoItemImportanceNumber = TodoItem.Importance.allCases.firstIndex(of: todoItem?.importance ?? .normal) ?? 0
        todoItemDeadline = todoItem?.deadline ?? Date(timeIntervalSinceNow: 24 * 60 * 60)
        todoItemHasDeadline = todoItem?.deadline != nil
        todoItemHexColorValue = todoItem?.hexColor ?? "#FFFFFF"
        todoItemColor = Color.convertFromHex(todoItem?.hexColor ?? "#FFFFFF") ?? .white
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
            hexColor: todoItemHexColorValue
        )
        
        todoItem = updatedItem
        
        dataService.update(updatedItem)
    }
    
    func deleteTodoItem() {
        dataService.delete(todoItem)
    }
}
