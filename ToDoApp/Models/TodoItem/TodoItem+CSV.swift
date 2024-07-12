//
//  TodoItem+CSV.swift
//  ToDoApp
//
//  Created by Rafis on 09.07.2024.
//

import Foundation

// MARK: - Extension CSV
extension TodoItem {
    static func parse(csv: Any) -> TodoItem? {
        guard let csvString = csv as? String else { return nil }
        let components = parseCSVLine(csvString)
        guard components.count >= PropertyName.allCases.count else { return nil }
        
        let id = components[0]
        let text = components[1]
        guard let importance = Importance(rawValue: components[2]) else { return nil }
        let deadline = TimeInterval(components[3]).flatMap { Date(timeIntervalSince1970: $0) }
        guard let isDone = Bool(components[4]) else { return nil }
        let creationDate = Date(timeIntervalSince1970: TimeInterval(components[5]) ?? 0)
        let modifyDate = TimeInterval(components[6]).flatMap { Date(timeIntervalSince1970: $0) }
        let hexColor = components[7]
        let categoryId = components[8]
        let categoryName = components[9]
        let categoryHexColor = components[10]
        
        let category: TodoItemCategory?
        if !categoryId.isEmpty && !categoryName.isEmpty && !categoryHexColor.isEmpty {
            category = TodoItemCategory(id: categoryId, name: categoryName, hexColor: categoryHexColor)
        } else {
            category = nil
        }
        
        return TodoItem(
            id: id,
            text: text,
            importance: importance,
            deadline: deadline,
            isDone: isDone,
            creationDate: creationDate,
            modifyDate: modifyDate,
            hexColor: hexColor,
            category: category
        )
    }
    
    var csv: Any {
        var csvString = "\(id),\"\(text)\",\(importance.rawValue),"
        csvString += deadline?.timeIntervalSince1970.description ?? ""
        csvString += ",\(isDone),\(creationDate.timeIntervalSince1970)"
        if let modifyDate = modifyDate {
            csvString += ",\(modifyDate.timeIntervalSince1970)"
        } else {
            csvString += ","
        }
        csvString += ",\(hexColor),"
        if let category = category {
            csvString += "\(category.id),\(category.name),\(category.hexColor ?? "")"
        } else {
            csvString += ","
        }
        return csvString
    }
}

// MARK: - Private Extension
private extension TodoItem {
    // MARK: Static Methods
    static func parseCSVLine(_ line: String) -> [String] {
        var results = [String]()
        var value = ""
        var insideQuotes = false
        
        line.forEach { character in
            if character == "\"" {
                insideQuotes.toggle()
            } else if character == "," && !insideQuotes {
                results.append(value)
                value = ""
            } else {
                value.append(character)
            }
        }
        
        results.append(value)
        return results
    }
}
