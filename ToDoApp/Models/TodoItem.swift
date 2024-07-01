//
//  TodoItem.swift
//  TestRepoToDo_Yandex
//
//  Created by Rafis on 18.06.2024.
//

import Foundation

struct TodoItem: Identifiable {
    let id: String
    let text: String
    let importance: Importance
    let deadline: Date?
    let isDone: Bool
    let creationDate: Date
    let modifyDate: Date?
    let hexColor: String
    
    enum Importance: String, CaseIterable {
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
        creationDate: Date = Date(),
        modifyDate: Date?,
        hexColor: String = "#FFFFFF"
    ) {
        self.id = id
        self.text = text
        self.importance = importance
        self.deadline = deadline
        self.isDone = isDone
        self.creationDate = creationDate
        self.modifyDate = modifyDate
        self.hexColor = hexColor
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
        
        return dictionary
    }
}

// MARK: - Extension CSV
extension TodoItem {
    static func parse(csv: Any) -> TodoItem? {
        guard let csvString = csv as? String else { return nil }
        let components = parseCSVLine(csvString)
        guard components.count == PropertyName.allCases.count else { return nil }
        
        let id = components[0]
        let text = components[1]
        guard let importance = Importance(rawValue: components[2]) else { return nil }
        let deadline = TimeInterval(components[3]).flatMap { Date(timeIntervalSince1970: $0) }
        guard let isDone = Bool(components[4]) else { return nil }
        let creationDate = Date(timeIntervalSince1970: TimeInterval(components[5]) ?? 0)
        let modifyDate = TimeInterval(components[6]).flatMap { Date(timeIntervalSince1970: $0) }
        let hexColor = components[7]
        
        return TodoItem(
            id: id,
            text: text,
            importance: importance,
            deadline: deadline,
            isDone: isDone,
            creationDate: creationDate,
            modifyDate: modifyDate,
            hexColor: hexColor
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
        csvString += ",\(hexColor)"
        return csvString
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
        var hexColor: String?
        
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
                if let timeInterval = dictionary[$0.rawValue] as? TimeInterval {
                    deadline = .init(timeIntervalSince1970: timeInterval)
                }
            case .isDone:
                isDone = dictionary[$0.rawValue] as? Bool
            case .creationDate:
                if let timeInterval = dictionary[$0.rawValue] as? TimeInterval {
                    creationDate = .init(timeIntervalSince1970: timeInterval)
                }
            case .modifyDate:
                if let timeInterval = dictionary[$0.rawValue] as? TimeInterval {
                    modifyDate = .init(timeIntervalSince1970: timeInterval)
                }
            case .hexColor:
                hexColor = dictionary[$0.rawValue] as? String
            }
        }
        
        guard let id = id,
              let text = text,
              let importance = importance,
              let isDone = isDone,
              let creationDate = creationDate,
              let hexColor = hexColor
        else { return nil }
        
        return TodoItem(
            id: id,
            text: text,
            importance: importance,
            deadline: deadline,
            isDone: isDone,
            creationDate: creationDate,
            modifyDate: modifyDate,
            hexColor: hexColor
        )
    }
    
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
    
    // MARK: Properties
    enum PropertyName: String, CaseIterable {
        case id
        case text
        case importance
        case deadline
        case isDone
        case creationDate
        case modifyDate
        case hexColor
    }
}
