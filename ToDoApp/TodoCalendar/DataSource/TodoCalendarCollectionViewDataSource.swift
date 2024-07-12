//
//  TodoCalendarCollectionViewDataSource.swift
//  ToDoApp
//
//  Created by Rafis on 03.07.2024.
//

import UIKit

final class TodoCalendarCollectionViewDataSource: NSObject, UICollectionViewDataSource {
    // MARK: - Private Properties
    private let viewModel: TodoCalendarCollectionViewModelProtocol
    
    // MARK: - Initialization
    init(_ viewModel: TodoCalendarViewModelProtocol) {
        self.viewModel = viewModel
    }
    
    // MARK: - Internal Methods
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.getCollectionViewNumberOfItemsInSection()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: TodoCalendarCollectionViewCell.identifier,
            for: indexPath
        ) as? TodoCalendarCollectionViewCell
        else { return UICollectionViewCell() }
        
        let uniqueDateNumberAndText = viewModel.getUniqueDate(with: indexPath.item)
            .split(separator: " ")
            .map { String($0) }
        cell.setDateNumberLabel(text: uniqueDateNumberAndText.first)
        cell.setDateTextLabel(text: uniqueDateNumberAndText.count > 1 ? uniqueDateNumberAndText.last : "")

        return cell
    }
}
