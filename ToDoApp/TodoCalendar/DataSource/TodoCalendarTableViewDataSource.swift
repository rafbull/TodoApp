//
//  TodoCalendarTableViewDataSource.swift
//  ToDoApp
//
//  Created by Rafis on 02.07.2024.
//

import UIKit

final class TodoCalendarTableViewDataSource: NSObject, UITableViewDataSource {
    // MARK: - Private Properties
    private let viewModel: TodoCalendarTableViewModelProtocol
    
    // MARK: - Initialization
    init(_ viewModel: TodoCalendarViewModelProtocol) {
        self.viewModel = viewModel
    }
    
    // MARK: - Internal Methods
    func numberOfSections(in tableView: UITableView) -> Int {
        viewModel.getTableViewSectionsCount()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.getTableViewNumberOfRowsInSection(section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: TodoCalendarTableViewCell.identifier,
            for: indexPath
        ) as? TodoCalendarTableViewCell
        else { return UITableViewCell() }
        
        guard let todoCalendarModel = viewModel.getTodoItemModel(with: indexPath) else { return UITableViewCell() }
        
        cell.setTodoTextLabel(text: todoCalendarModel.attributedText, isStrikethrough: todoCalendarModel.isDone)
        
        if let categoryHexColor = todoCalendarModel.category?.hexColor,
           let categoryColor = UIColor.convertFromHex(categoryHexColor, alpha: 1.0) {
            cell.setTodoCategoryImage(color: categoryColor)
        } else {
            cell.setTodoCategoryImage(color: .clear)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        viewModel.getTableViewHeaderTitleForSection(section)
    }
}
