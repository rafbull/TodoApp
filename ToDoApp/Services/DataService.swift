//
//  DataService.swift
//  ToDoApp
//
//  Created by Rafis on 28.06.2024.
//

import Foundation

protocol DataServiceProtocol {
    func getTodoItems(completion: ([TodoItem]) -> Void)
    func update(_ todoItem: TodoItem)
    func delete(_ todoItem: TodoItem)
}

final class DataService: DataServiceProtocol {
    // MARK: - Private Properties
    private var todoItems = [TodoItem]()
    
    // MARK: - Initialization
    init() {
        createMockData()
    }
    
    // MARK: - Internal Methods
    func getTodoItems(completion: ([TodoItem]) -> Void) {
        completion(todoItems)
    }
    
    func update(_ todoItem: TodoItem) {
        if let index = todoItems.firstIndex(where: { $0.id == todoItem.id }) {
            todoItems[index] = todoItem
        } else {
            todoItems.append(todoItem)
        }
    }
    
    func delete(_ todoItem: TodoItem) {
        guard let index = todoItems.firstIndex(where: { $0.id == todoItem.id }) else { return }
        todoItems.remove(at: index)
    }
}

// MARK: - Private Extension
private extension DataService {
    func createMockData() {
        todoItems = [
            .init(
                text: "1_Купить что-то, где-то, зачем-то, но зачем не очень понятно, Купить что-то, где-то, зачем-то, но зачем не очень понятно",
                importance: .important,
                deadline: .now + 42 * 60 * 60,
                isDone: false,
                modifyDate: nil
            ),
            .init(
                text: "2_Second",
                importance: .normal,
                deadline: nil,
                isDone: true,
                modifyDate: nil
            ),
            .init(
                text: "3_Купить что-то, где-то, зачем-то, но зачем не очень понятно, Купить что-то, где-то, зачем-то, но зачем не очень понятно",
                importance: .unimportant,
                deadline: nil,
                isDone: false,
                modifyDate: nil
            )
        ]
    }
}
