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
    
    enum FileType {
        case json
        case csv
    }
    
    // MARK: - Internal Methods
    func addItem(_ todoItem: TodoItem) throws {
        guard todoItems[todoItem.id] == nil else { throw FileCacheError.badId(todoItem.id) }
        todoItems[todoItem.id] = todoItem
    }
    
    func removeItem(by id: String) -> TodoItem? {
        todoItems.removeValue(forKey: id)
    }
    
    func saveFile(_ fileName: String, as type: FileType) throws {
        let fileURL = URL(fileURLWithPath: fileName, relativeTo: documentDirectory)

        switch type {
        case .json:
            let jsonArray = todoItems.values.map { $0.json }
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: jsonArray, options: .prettyPrinted)
                try jsonData.write(to: fileURL)
            } catch {
                throw error
            }
        case .csv:
            let csvArray = todoItems.values.compactMap { $0.csv as? String }
            let csvString = csvArray.joined(separator: "\n")
            do {
                try csvString.write(to: fileURL, atomically: true, encoding: .utf8)
            } catch {
                throw error
            }
        }
    }
    
    func loadFile(_ fileName: String, as type: FileType) throws {
        let fileURL = URL(fileURLWithPath: fileName, relativeTo: documentDirectory)

        switch type {
        case .json:
            do {
                let data = try Data(contentsOf: fileURL)
                if let json = try JSONSerialization.jsonObject(with: data) as? [[String: Any]] {
                    let todoItems = json.compactMap { TodoItem.parse(json: $0) }
                    try todoItems.forEach { try addItem($0) }
                }
            } catch {
                throw error
            }
        case .csv:
            do {
                let csvString = try String(contentsOf: fileURL, encoding: .utf8)
                let csvLines = csvString.split(separator: "\n")
                let todoItems = csvLines.compactMap { TodoItem.parse(csv: String($0)) }
                try todoItems.forEach { try addItem($0) }
            } catch {
                throw error
            }
        }
    }
}

// MARK: - Private Extension
private extension FileCache {
    var documentDirectory: URL? {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
    }
}
