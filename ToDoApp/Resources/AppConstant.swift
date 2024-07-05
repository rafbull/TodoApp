//
//  AppConstant.swift
//  ToDoApp
//
//  Created by Rafis on 05.07.2024.
//

import Foundation

enum AppConstant {
    enum TodoItemCategory {
        static let workName = "Работа"
        static let studyName = "Учеба"
        static let hobbyName = "Хобби"
        static let otherName = "Другое"
        
        static let workHexColor = "#FF0000"
        static let studyHexColor = "#0000FF"
        static let hobbyHexColor = "#008000"
        static let otherHexColor: String? = nil
    }
}
