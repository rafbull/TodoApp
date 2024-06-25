//
//  FileCacheError.swift
//  TestRepoToDo_Yandex
//
//  Created by Rafis on 19.06.2024.
//

import Foundation

enum FileCacheError: LocalizedError {
case badId(_ id: String)
}

extension FileCacheError {
    var errorDescription: String {
        switch self {
        case .badId(let id):
            return "⚠️ This TodoItem ID is already in use! ID: \"\(id)\""
        }
    }
}
