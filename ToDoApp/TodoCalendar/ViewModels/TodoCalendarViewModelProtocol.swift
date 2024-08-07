//
//  TodoCalendarViewModelProtocol.swift
//  ToDoApp
//
//  Created by Rafis on 03.07.2024.
//

import Foundation
import Combine

typealias TodoCalendarViewModelProtocol = TodoCalendarTableViewModelProtocol & TodoCalendarCollectionViewModelProtocol

protocol TodoCalendarTableViewModelProtocol {
    var displayingSectionIndex: CurrentValueSubject<Int, Never> { get }
    var isDataChanged: CurrentValueSubject<Bool, Never> { get }
    
    func getTableViewSectionsCount() -> Int
    func getTableViewNumberOfRowsInSection(_ section: Int) -> Int
    func getTodoItemModel(with indexPath: IndexPath) -> TodoCalendarModel?
    func getTableViewHeaderTitleForSection(_ section: Int) -> String
    
    func didEndDisplaying(for section: Int)
    
    func didSwipe(at indexPath: IndexPath, isLeading: Bool)
    func didSelectRowAt(at indexPath: IndexPath)
}

protocol TodoCalendarCollectionViewModelProtocol {
    var dateSelectedIndex: CurrentValueSubject<Int, Never> { get }
    
    func getCollectionViewNumberOfItemsInSection() -> Int
    func getUniqueDate(with index: Int) -> String
    
    func collectionViewDidSelectItemAt(at index: Int)
}
