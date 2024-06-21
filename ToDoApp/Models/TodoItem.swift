//
//  TodoItem.swift
//  TestRepoToDo_Yandex
//
//  Created by Rafis on 18.06.2024.
//

import Foundation

struct TodoItem {
    let id: String
    let text: String
    let importance: Importance
    let deadline: Date?
    let isDone: Bool
    let creationDate: Date
    let modifyDate: Date?
    
    enum Importance: String {
        case unimportant
        case normal
        case important
    }
    
    // MARK: - Initialization
    init(
        id: String = UUID().uuidString,
        text: String,
        importance: Importance,
        deadline: Date?,
        isDone: Bool,
        creationDate: Date,
        modifyDate: Date?
    ) {
        self.id = id
        self.text = text
        self.importance = importance
        self.deadline = deadline
        self.isDone = isDone
        self.creationDate = creationDate
        self.modifyDate = modifyDate
    }
}

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
        convertToDictionary()
    }
}


// MARK: - Extension CSV
extension TodoItem {
    static func parse(csv: Any) -> TodoItem? {
        nil
    }
    
    var csv: Any {
        ""
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
        var id: String?
        var text: String?
        var importance: Importance?
        var deadline: Date?
        var isDone: Bool?
        var creationDate: Date?
        var modifyDate: Date?
        
        PropertyName.allCases.forEach {
            switch $0 {
            case .id:
                id = dictionary[$0.rawValue] as? String
            case .text:
                text = dictionary[$0.rawValue] as? String
            case .importance:
                if let rawValue = dictionary[$0.rawValue] as? String {
                    importance = .init(rawValue: rawValue)
                } else {
                    importance = .normal
                }
            case .deadline:
                if let deadlineString = dictionary[$0.rawValue] as? String,
                   let timeInterval = TimeInterval(deadlineString) {
                    deadline = .init(timeIntervalSince1970: timeInterval)
                }
            case .isDone:
                isDone = dictionary[$0.rawValue] as? Bool
            case .creationDate:
                if let creationDateString = dictionary[$0.rawValue] as? String,
                   let timeInterval = TimeInterval(creationDateString) {
                    creationDate = .init(timeIntervalSince1970: timeInterval)
                }
            case .modifyDate:
                if let modifyDateString = dictionary[$0.rawValue] as? String,
                   let timeInterval = TimeInterval(modifyDateString) {
                    modifyDate = .init(timeIntervalSince1970: timeInterval)
                }
            }
        }
        
        guard let id = id,
              let text = text,
              let importance = importance,
              let isDone = isDone,
              let creationDate = creationDate
        else { return nil }
        
        return TodoItem(
            id: id,
            text: text,
            importance: importance,
            deadline: deadline,
            isDone: isDone,
            creationDate: creationDate,
            modifyDate: modifyDate
        )
    }
    
    // MARK: Properties
    enum PropertyName: String, CaseIterable {
        case id
        case text
        case importance
        case deadline
        case isDone
        case creationDate
        case modifyDate
    }
    
    // MARK: Methods
    func convertToDictionary() -> [String: Any] {
        var dictionary: [String: Any] = [
            PropertyName.id.rawValue: id,
            PropertyName.text.rawValue: text,
            PropertyName.isDone.rawValue: isDone,
            PropertyName.creationDate.rawValue: String(creationDate.timeIntervalSince1970),
        ]
        
        if importance != .normal {
            dictionary[PropertyName.importance.rawValue] = importance.rawValue
        }
        
        if let deadline = deadline {
            dictionary[PropertyName.deadline.rawValue] = String(deadline.timeIntervalSince1970)
        }
        
        if let modifyDate = modifyDate {
            dictionary[PropertyName.modifyDate.rawValue] = String(modifyDate.timeIntervalSince1970)
        }
        
        return dictionary
    }
}
