//
//  TodoCalendarAssembly.swift
//  ToDoApp
//
//  Created by Rafis on 02.07.2024.
//

import UIKit

enum TodoCalendarAssembly {
    struct Dependencies {
        let navigationController: UINavigationController
        let dataService: DataServiceProtocol
    }
    
    static func makeModule(with dependencies: Dependencies) -> TodoCalendarViewController {
        let router = TodoCalendarRouter(navigationController: dependencies.navigationController)
        let viewModel = TodoCalendarViewModel(router: router, dataService: dependencies.dataService)
        let viewController = TodoCalendarViewController(viewModel: viewModel)
        
        return viewController
    }
}
