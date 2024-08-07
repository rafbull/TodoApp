//
//  ToDoAppApp.swift
//  ToDoApp
//
//  Created by Rafis on 21.06.2024.
//

import SwiftUI

@main
struct ToDoAppApp: App {
    private let todoListViewModel = TodoListViewModel(dataService: DataService(), networkService: NetworkService())
    
    var body: some Scene {
        WindowGroup {
            TodoListView(viewModel: todoListViewModel)
        }
    }
    
    init() {
        Logger.setupLogger()
    }
}
