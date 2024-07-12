//
//  TodoCalendarModel.swift
//  ToDoApp
//
//  Created by Rafis on 02.07.2024.
//

import Foundation

struct TodoCalendarModel {
    let id: String
    var attributedText: NSAttributedString
    let deadLine: Date?
    let isDone: Bool
    let category: TodoItemCategory?
}

extension TodoCalendarModel {
    init(with todoItem: TodoItem) {
        id = todoItem.id
        attributedText = NSAttributedString(string: todoItem.text)
        deadLine = todoItem.deadline
        isDone = todoItem.isDone
        category = todoItem.category
    }
}
