//
//  ToDoAppTests.swift
//  ToDoAppTests
//
//  Created by Rafis on 21.06.2024.
//

import XCTest
@testable import ToDoApp

class ToDoAppTests: XCTestCase {

    func testTodoItemInitialization() {
        let id = "testID"
        let text = "Test Todo"
        let importance = TodoItem.Importance.important
        let deadline = Date(timeIntervalSince1970: 1000)
        let isDone = true
        let creationDate = Date(timeIntervalSince1970: 500)
        let modifyDate = Date(timeIntervalSince1970: 1500)
        let hexColor = "#FF5733"
        let category = TodoItem.Category(name: "Работа", hexColor: "#0000FF")

        let todoItem = TodoItem(
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

        XCTAssertEqual(todoItem.id, id)
        XCTAssertEqual(todoItem.text, text)
        XCTAssertEqual(todoItem.importance, importance)
        XCTAssertEqual(todoItem.deadline, deadline)
        XCTAssertEqual(todoItem.isDone, isDone)
        XCTAssertEqual(todoItem.creationDate, creationDate)
        XCTAssertEqual(todoItem.modifyDate, modifyDate)
        XCTAssertEqual(todoItem.hexColor, hexColor)
        XCTAssertEqual(todoItem.category, category)
    }

    func testTodoItemJSONSerialization() {
        let todoItem = TodoItem(
            id: "testID",
            text: "Test Todo",
            importance: .important,
            deadline: Date(timeIntervalSince1970: 1000),
            isDone: true,
            creationDate: Date(timeIntervalSince1970: 500),
            modifyDate: Date(timeIntervalSince1970: 1500),
            hexColor: "#FF5733",
            category: TodoItem.Category(name: "Работа", hexColor: "#0000FF")
        )

        let json = todoItem.json as? [String: Any]
        XCTAssertNotNil(json)
        XCTAssertEqual(json?["id"] as? String, "testID")
        XCTAssertEqual(json?["text"] as? String, "Test Todo")
        XCTAssertEqual(json?["importance"] as? String, "important")
        XCTAssertEqual(json?["deadline"] as? TimeInterval, 1000)
        XCTAssertEqual(json?["isDone"] as? Bool, true)
        XCTAssertEqual(json?["creationDate"] as? TimeInterval, 500)
        XCTAssertEqual(json?["modifyDate"] as? TimeInterval, 1500)
        XCTAssertEqual(json?["hexColor"] as? String, "#FF5733")
        if let category = json?["category"] as? [String: Any] {
            XCTAssertEqual(category["name"] as? String, "Работа")
            XCTAssertEqual(category["hexColor"] as? String, "#0000FF")
        } else {
            XCTFail("Category should not be nil")
        }
    }

    func testTodoItemJSONDeserialization() {
        let json: [String: Any] = [
            "id": "testID",
            "text": "Test Todo",
            "importance": "important",
            "deadline": 1000.0,
            "isDone": true,
            "creationDate": 500.0,
            "modifyDate": 1500.0,
            "hexColor": "#FF5733",
            "category": [
                "id": "testCategoryID",
                "name": "Работа",
                "hexColor": "#0000FF"
            ]
        ]

        let todoItem = TodoItem.parse(json: json)
        XCTAssertNotNil(todoItem)
        XCTAssertEqual(todoItem?.id, "testID")
        XCTAssertEqual(todoItem?.text, "Test Todo")
        XCTAssertEqual(todoItem?.importance, .important)
        XCTAssertEqual(todoItem?.deadline, Date(timeIntervalSince1970: 1000))
        XCTAssertEqual(todoItem?.isDone, true)
        XCTAssertEqual(todoItem?.creationDate, Date(timeIntervalSince1970: 500))
        XCTAssertEqual(todoItem?.modifyDate, Date(timeIntervalSince1970: 1500))
        XCTAssertEqual(todoItem?.hexColor, "#FF5733")
        XCTAssertEqual(todoItem?.category, TodoItem.Category(id: "testCategoryID", name: "Работа", hexColor: "#0000FF"))
    }

    func testTodoItemCSVSerialization() {
        let todoItem = TodoItem(
            id: "testID",
            text: "Test Todo",
            importance: .important,
            deadline: Date(timeIntervalSince1970: 1000),
            isDone: true,
            creationDate: Date(timeIntervalSince1970: 500),
            modifyDate: Date(timeIntervalSince1970: 1500),
            hexColor: "#FF5733",
            category: TodoItem.Category(id: "testCategoryID", name: "Работа", hexColor: "#0000FF")
        )

        let csv = todoItem.csv as? String
        let expectedCSV = "testID,\"Test Todo\",important,1000.0,true,500.0,1500.0,#FF5733,testCategoryID,Работа,#0000FF"
        XCTAssertEqual(csv, expectedCSV)
    }

    func testTodoItemCSVDeserialization() {
        let csv = "testID,\"Test Todo\",important,1000.0,true,500.0,1500.0,#FF5733,testCategoryID,Работа,#0000FF"
        let todoItem = TodoItem.parse(csv: csv)

        XCTAssertNotNil(todoItem)
        XCTAssertEqual(todoItem?.id, "testID")
        XCTAssertEqual(todoItem?.text, "Test Todo")
        XCTAssertEqual(todoItem?.importance, .important)
        XCTAssertEqual(todoItem?.deadline, Date(timeIntervalSince1970: 1000))
        XCTAssertEqual(todoItem?.isDone, true)
        XCTAssertEqual(todoItem?.creationDate, Date(timeIntervalSince1970: 500))
        XCTAssertEqual(todoItem?.modifyDate, Date(timeIntervalSince1970: 1500))
        XCTAssertEqual(todoItem?.hexColor, "#FF5733")
        XCTAssertEqual(todoItem?.category, TodoItem.Category(id: "testCategoryID", name: "Работа", hexColor: "#0000FF"))
    }
}
