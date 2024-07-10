//
//  TodoItem+JSON.swift
//  ToDoApp
//
//  Created by Rafis on 09.07.2024.
//

import Foundation

// MARK: - Extension JSON
extension TodoItem {
    static func parse(json: Any) -> TodoItem? {
        if let jsonDictionary = json as? [String: Any] {
            return convertFrom(dictionary: jsonDictionary)
            
        } else if let jsonData = json as? Data {
            return convertFrom(data: jsonData)
        }
        
        return nil
    }
    
    var json: Any {
        var dictionary: [String: Any] = [
            PropertyName.id.rawValue: id,
            PropertyName.text.rawValue: text,
            PropertyName.isDone.rawValue: isDone,
            PropertyName.creationDate.rawValue: creationDate.timeIntervalSince1970,
            PropertyName.hexColor.rawValue: hexColor
        ]
        
        if importance != .normal {
            dictionary[PropertyName.importance.rawValue] = importance.rawValue
        }
        
        if let deadline = deadline {
            dictionary[PropertyName.deadline.rawValue] = deadline.timeIntervalSince1970
        }
        
        if let modifyDate = modifyDate {
            dictionary[PropertyName.modifyDate.rawValue] = modifyDate.timeIntervalSince1970
        }
        
        if let category = category {
            dictionary[PropertyName.category.rawValue] = [
                Category.PropertyName.id.rawValue: category.id,
                Category.PropertyName.name.rawValue: category.name,
                Category.PropertyName.hexColor.rawValue: category.hexColor
            ]
        }
        
        return dictionary
    }
}

// MARK: - Private Extension
private extension TodoItem {
    // MARK: Static Methods
    static func convertFrom(data: Data) -> TodoItem? {
        do {
            guard let dictionary = try JSONSerialization.jsonObject(with: data) as? [String: Any]
            else { return nil }
            return convertFrom(dictionary: dictionary)
        } catch {
            return nil
        }
    }
    
    static func convertFrom(dictionary: [String: Any]) -> TodoItem? {
        guard let id = dictionary[PropertyName.id.rawValue] as? String,
              let text = dictionary[PropertyName.text.rawValue] as? String,
              let isDone = dictionary[PropertyName.isDone.rawValue] as? Bool,
              let creationDateInterval = dictionary[PropertyName.creationDate.rawValue] as? TimeInterval,
              let hexColor = dictionary[PropertyName.hexColor.rawValue] as? String
        else { return nil }
        
        let importance = (dictionary[PropertyName.importance.rawValue] as? String)
            .flatMap { Importance(rawValue: $0) } ?? .normal
        let deadline = (dictionary[PropertyName.deadline.rawValue] as? TimeInterval)
            .flatMap { Date(timeIntervalSince1970: $0) }
        let modifyDate = (dictionary[PropertyName.modifyDate.rawValue] as? TimeInterval)
            .flatMap { Date(timeIntervalSince1970: $0) }
        
        let category: Category?
        if let categoryDict = dictionary[PropertyName.category.rawValue] as? [String: Any],
           let categoryId = categoryDict[Category.PropertyName.id.rawValue] as? String,
           let categoryName = categoryDict[Category.PropertyName.name.rawValue] as? String,
           let categoryHexColor = categoryDict[Category.PropertyName.hexColor.rawValue] as? String {
            category = Category(id: categoryId, name: categoryName, hexColor: categoryHexColor)
        } else {
            category = nil
        }
        
        return TodoItem(
            id: id,
            text: text,
            importance: importance,
            deadline: deadline,
            isDone: isDone,
            creationDate: Date(timeIntervalSince1970: creationDateInterval),
            modifyDate: modifyDate,
            hexColor: hexColor,
            category: category
        )
    }
}
