//
//  TodoCalendarRouter.swift
//  ToDoApp
//
//  Created by Rafis on 02.07.2024.
//

import UIKit
import SwiftUI

final class TodoCalendarRouter {
    // MARK: - Private Properties
    private weak var navigationController: UINavigationController?
    
    // MARK: - Initialization
    init(navigationController: UINavigationController?) {
        self.navigationController = navigationController
    }
    
    // MARK: - Internal Methods
    func showTodoItemDetailView(with todoItem: TodoItem, dataService: DataServiceProtocol) {
        guard let navigationController = navigationController else { return }
        let todoItemDetailView = TodoDetailView(
            viewModel: TodoDetailViewModel(todoItem: todoItem, dataService: dataService),
            textEditorText: todoItem.text
        )
        let hostingController = UIHostingController(rootView: todoItemDetailView)
        navigationController.present(hostingController, animated: true)
    }
}
