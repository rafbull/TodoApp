//
//  FileCacheError.swift
//  
//
//  Created by Rafis on 10.07.2024.
//

import Foundation

public enum FileCacheError: LocalizedError {
    case badId(_ id: String)
    case cantSaveFile(_ error: Error)
    case cantLoadFile(_ error: Error)
}

extension FileCacheError {
    var errorDescription: String {
        switch self {
        case .badId(let id):
            return "⚠️ This TodoItem ID is already in use! ID: \"\(id)\""
        case .cantSaveFile(let error):
            return "⚠️ Can't save to file: \"\(error)\""
        case .cantLoadFile(let error):
            return "⚠️ Can't load from file: \"\(error)\""
        }
    }
}
