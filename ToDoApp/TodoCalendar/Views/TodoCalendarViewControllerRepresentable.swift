//
//  TodoCalendarViewControllerRepresentable.swift
//  ToDoApp
//
//  Created by Rafis on 02.07.2024.
//

import SwiftUI

struct TodoCalendarViewControllerRepresentable: UIViewControllerRepresentable {
    let dataService: DataServiceProtocol
    
    func makeUIViewController(context: Context) -> UINavigationController {
        let navigationController = UINavigationController()
        let dependencies = TodoCalendarAssembly.Dependencies(navigationController: navigationController, dataService: dataService)
        let viewController = TodoCalendarAssembly.makeModule(with: dependencies)
        navigationController.viewControllers = [viewController]
        return navigationController
    }
    
    func updateUIViewController(_ uiViewController: UINavigationController, context: Context) {
        
    }
}
