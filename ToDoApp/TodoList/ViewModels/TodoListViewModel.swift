//
//  TodoListViewModel.swift
//  ToDoApp
//
//  Created by Rafis on 26.06.2024.
//

import Foundation

final class TodoListViewModel: ObservableObject {
    // MARK: - Internal Properties
    @Published var todoItems = [TodoItem]() {
        didSet {
            updateIsDoneItemsCount()
        }
    }
    
    @Published var isDoneCount = 0
    
    var notDoneTodoItems: [TodoItem] {
        todoItems.filter { !$0.isDone }
    }
    
    var sortedByImportance: [TodoItem] {
        todoItems.sorted { lhs, rhs in
            if let lhsIndex = TodoItem.Importance.allCases.firstIndex(of: lhs.importance),
               let rhsIndex = TodoItem.Importance.allCases.firstIndex(of: rhs.importance)
            {
                return lhsIndex > rhsIndex
            }
            return false
        }
    }
    
    let dataService: DataServiceProtocol
    
    // MARK: - Initialization
    init(dataService: DataServiceProtocol) {
        self.dataService = dataService
        getTodoItems()
    }
    
    // MARK: - Internal Methods
    func markAs(isDone: Bool, _ todoItem: TodoItem) {
        let updatedItem = TodoItem(
            id: todoItem.id,
            text: todoItem.text,
            importance: todoItem.importance,
            deadline: todoItem.deadline,
            isDone: isDone,
            creationDate: todoItem.creationDate,
            modifyDate: todoItem.modifyDate
        )
        
        guard let index = todoItems.firstIndex(where: { $0.id == todoItem.id }) else { return }
        todoItems[index] = updatedItem
        dataService.addNewOrUpdate(updatedItem)
    }
    
    func addNewItem(with text: String) {
        
        let newItem = TodoItem(
            text: text,
            importance: .normal,
            deadline: nil,
            isDone: false,
            modifyDate: nil
        )
        todoItems.append(newItem)
        dataService.addNewOrUpdate(newItem)
    }
    
    func delete(_ todoItem: TodoItem) {
        guard let index = todoItems.firstIndex(where: { $0.id == todoItem.id }) else { return }
        todoItems.remove(at: index)
        dataService.delete(todoItem)
    }
    
    func viewIsOnAppear() {
        getTodoItems()
    }
}

// MARK: - Private Extension
private extension TodoListViewModel {
    func getTodoItems() {
        dataService.getTodoItems { [weak self] todoItems in
            self?.todoItems = todoItems
        }
    }
    
    func updateIsDoneItemsCount() {
        isDoneCount = todoItems.filter { $0.isDone }.count
    }
}
