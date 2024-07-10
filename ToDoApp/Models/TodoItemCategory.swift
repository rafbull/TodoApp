//
//  TodoItemCategory.swift
//  ToDoApp
//
//  Created by Rafis on 10.07.2024.
//

import Foundation

struct TodoItemCategory: Identifiable, Hashable {
    let id: String
    let name: String
    let hexColor: String?
    
    enum PropertyName: String {
        case id
        case name
        case hexColor
    }
    
    init(id: String = UUID().uuidString, name: String, hexColor: String?) {
        self.id = id
        self.name = name
        self.hexColor = hexColor
    }
}
