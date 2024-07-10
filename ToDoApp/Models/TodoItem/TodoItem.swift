//
//  TodoItem.swift
//  TestRepoToDo_Yandex
//
//  Created by Rafis on 18.06.2024.
//

import Foundation

struct TodoItem: Identifiable, Hashable {
    let id: String
    let text: String
    let importance: Importance
    let deadline: Date?
    let isDone: Bool
    let creationDate: Date
    let modifyDate: Date?
    let hexColor: String
    let category: TodoItemCategory?
    
    // MARK: - Initialization
    init(
        id: String = UUID().uuidString,
        text: String,
        importance: Importance,
        deadline: Date?,
        isDone: Bool,
        creationDate: Date = Date(),
        modifyDate: Date?,
        hexColor: String = "#FFFFFF",
        category: TodoItemCategory?
    ) {
        self.id = id
        self.text = text
        self.importance = importance
        self.deadline = deadline
        self.isDone = isDone
        self.creationDate = creationDate
        self.modifyDate = modifyDate
        self.hexColor = hexColor
        self.category = category
    }
}

// MARK: - Extension
extension TodoItem {
    enum Importance: String, CaseIterable {
        case unimportant
        case normal
        case important
    }
    
//    struct Category: Identifiable, Hashable {
//        let id: String
//        let name: String
//        let hexColor: String?
//        
//        enum PropertyName: String {
//            case id
//            case name
//            case hexColor
//        }
//        
//        init(id: String = UUID().uuidString, name: String, hexColor: String?) {
//            self.id = id
//            self.name = name
//            self.hexColor = hexColor
//        }
//    }
    
    enum PropertyName: String, CaseIterable {
        case id
        case text
        case importance
        case deadline
        case isDone
        case creationDate
        case modifyDate
        case hexColor
        case category
    }
}
