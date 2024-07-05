//
//  TodoCalendarViewModel.swift
//  ToDoApp
//
//  Created by Rafis on 02.07.2024.
//

import Foundation
import Combine

final class TodoCalendarViewModel: TodoCalendarViewModelProtocol {
    // MARK: - Internal Properties
    private(set) var dateSelectedIndex = CurrentValueSubject<Int, Never>(0)
    private(set) var displayingSectionIndex = CurrentValueSubject<Int, Never>(0)
    private(set) var isDataChanged = CurrentValueSubject<Bool, Never>(false)
    
    // MARK: - Private Properties
    private var todoItems = [TodoItem]()
    private let dataService: DataServiceProtocol
    private let router: TodoCalendarRouter
    private var subscriptions = Set<AnyCancellable>()
    
    private let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.dateFormat = "d MMMM"
        return dateFormatter
    }()
    
    private var uniqueDates: [String] {
        var uniqueDates = Set(todoItems.compactMap { $0.deadline })
            .sorted()
            .map { dateFormatter.string(from: $0) }
            .reduce(into: [String]()) { uniqueStrings, date in
                if !uniqueStrings.contains(date) {
                    uniqueStrings.append(date)
                }
            }
        uniqueDates.append(Section.other.rawValue)
        return uniqueDates
    }
    
    private var datesAndCount: [String: Int] {
        var datesAndCount = [String: Int]()
        uniqueDates.forEach { date in
            let count = (date == Section.other.rawValue) ?
                todoItems.filter { $0.deadline == nil }.count :
                todoItems.compactMap { $0.deadline }.filter { dateFormatter.string(from: $0) == date }.count
            datesAndCount[date] = count
        }
        return datesAndCount
    }
    
    private enum Section: String {
        case other = "Другое"
    }
    
    // MARK: - Initialization
    init(router: TodoCalendarRouter, dataService: DataServiceProtocol) {
        self.router = router
        self.dataService = dataService
        getTodoItems()
    }
    
    // MARK: - Internal Methods
    // MARK: TableView DataSource Setup Methods
    func getTableViewSectionsCount() -> Int {
        uniqueDates.count
    }
    
    func getTableViewNumberOfRowsInSection(_ section: Int) -> Int {
        datesAndCount[uniqueDates[section]] ?? 0
    }
    
    func getTodoItemModel(with indexPath: IndexPath) -> TodoCalendarModel? {
        guard let todoItem = getItemForDate(at: indexPath) else { return nil }
        
        var todoCalendarModel = TodoCalendarModel(with: todoItem)
        todoCalendarModel.attributedText = setupTodoItemText(todoItem.text, isDone: todoItem.isDone)
        return todoCalendarModel
    }
    
    func getTableViewHeaderTitleForSection(_ section: Int) -> String {
        uniqueDates[section]
    }
    
    func didEndDisplaying(for section: Int) {
        guard section < uniqueDates.count else { return }
        dateSelectedIndex.send(section)
    }
    
    func didSwipe(at indexPath: IndexPath, isLeading: Bool) {
        guard let selectedItem = getItemForDate(at: indexPath) else { return }
        
        let updatedItem = TodoItem(
            id: selectedItem.id,
            text: selectedItem.text,
            importance: selectedItem.importance,
            deadline: selectedItem.deadline,
            isDone: isLeading,
            creationDate: selectedItem.creationDate,
            modifyDate: selectedItem.modifyDate,
            category: selectedItem.category
        )
        
        if let index = todoItems.firstIndex(where: { $0.id == updatedItem.id }) {
            todoItems[index] = updatedItem
            dataService.addNewOrUpdate(updatedItem)
        }
    }
    
    func didSelectRowAt(at indexPath: IndexPath) {
        guard let selectedItem = getItemForDate(at: indexPath) else { return }
        router.showTodoItemDetailView(with: selectedItem, dataService: dataService)
    }
    
    // MARK: CollectionView DataSource Setup Methods
    func getCollectionViewNumberOfItemsInSection() -> Int {
        uniqueDates.count
    }
    
    func getUniqueDate(with index: Int) -> String {
        guard index < uniqueDates.count else { return "" }
        return uniqueDates[index]
    }
    
    func collectionViewDidSelectItemAt(at index: Int) {
        guard index < uniqueDates.count else { return }
        displayingSectionIndex.send(index)
    }
}

// MARK: - Private Extension
private extension TodoCalendarViewModel {
    func getTodoItems() {
        dataService.todoItems
            .sink { [weak self] todoItems in
                self?.todoItems = todoItems
                self?.isDataChanged.send(true)
            }
            .store(in: &subscriptions)
    }
    
    func setupTodoItemText(_ text: String, isDone: Bool) -> NSAttributedString {
        let attributedString = NSMutableAttributedString(string: text)
        let range = NSRange(location: .zero, length: text.count)
        
        if isDone {
            attributedString.addAttribute(
                NSAttributedString.Key.strikethroughStyle,
                value: 1,
                range: range
            )
        }
        
        return attributedString
    }
    
    func getItemForDate(at indexPath: IndexPath) -> TodoItem? {
        guard indexPath.section < uniqueDates.count else { return nil }
        
        let uniqueDate = uniqueDates[indexPath.section]
        let itemsForDate = todoItems.filter {
            guard let deadline = $0.deadline else { return uniqueDate == Section.other.rawValue }
            return dateFormatter.string(from: deadline) == uniqueDate
        }
        
        guard indexPath.row < itemsForDate.count else { return nil }
        let itemForDate = itemsForDate[indexPath.row]
        
        return itemForDate
    }
}
