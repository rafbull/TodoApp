//
//  FileCache.swift
//  TestRepoToDo_Yandex
//
//  Created by Rafis on 18.06.2024.
//

import Foundation

final class FileCache {
    // MARK: - Internal Properties
    private(set) var todoItems = [String: TodoItem]()
    
    // MARK: - Internal Methods
    func add(todoItem: TodoItem) throws {
        guard todoItems[todoItem.id] == nil else { throw FileCacheError.badID(todoItem.id) }
        todoItems[todoItem.id] = todoItem
    }
    
    func remove(todoItem: TodoItem) {
        todoItems.removeValue(forKey: todoItem.id)
    }
    
    func saveFile(_ fileName: String) throws {
        let fileURL = URL(fileURLWithPath: fileName, relativeTo: documentDirectory)
        let jsonArray = todoItems.values.map { $0.json }
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: jsonArray, options: .prettyPrinted)
            try jsonData.write(to: fileURL)
        } catch {
            throw error
        }
    }
    
    func loadFile(_ fileName: String) throws {
        let fileURL = URL(fileURLWithPath: fileName, relativeTo: documentDirectory)
        
        do {
            let data = try Data(contentsOf: fileURL)
            if let json = try JSONSerialization.jsonObject(with: data) as? [[String: Any]] {
                let todoItems = json.compactMap { TodoItem.parse(json: $0) }
                try todoItems.forEach { try add(todoItem: $0) }
            }
        } catch {
            throw error
        }
    }
}

// MARK: - Private Extension
private extension FileCache {
    var documentDirectory: URL? {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
    }
}
