//
//  TodoCalendarView.swift
//  ToDoApp
//
//  Created by Rafis on 02.07.2024.
//

import UIKit

final class TodoCalendarView: UIView {
    // MARK: - Internal Properties
    private(set) lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        collectionView.register(
            TodoCalendarCollectionViewCell.self,
            forCellWithReuseIdentifier:
                TodoCalendarCollectionViewCell.identifier
        )
        collectionView.backgroundColor = UIColor(AppColor.primaryBackground)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.register(
            TodoCalendarTableViewCell.self,
            forCellReuseIdentifier: TodoCalendarTableViewCell.identifier
        )
        tableView.backgroundColor = .init(AppColor.primaryBackground)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(AppColor.tertiaryLabel)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // MARK: - Private Constants
    private enum UIConstant {
        static let collectionViewHeightAnchorConstant: CGFloat = 96
        static let collectionViewItemSpacing: CGFloat = 8
        static let collectionViewGroupSpacing: CGFloat = 8
        static let collectionViewSectionContentInsets: NSDirectionalEdgeInsets = .init(top: 8, leading: 8, bottom: 8, trailing: 8)
        static let addTodoItemButtonSideSize: CGFloat = 56
        static let addTodoItemShadowRadius: CGFloat = 8
        static let addTodoItemShadowOpacity: Float = 0.5
        static let addTodoItemShadowOffset: CGSize = .init(width: 0, height: 5)
        static let separatorHeightAnchor: CGFloat = 1
    }
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Private Extension
private extension TodoCalendarView {
    func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { _, _ in
            
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalHeight(1.0), heightDimension: .fractionalHeight(1.0))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
            group.interItemSpacing = .fixed(UIConstant.collectionViewItemSpacing)
            
            let section = NSCollectionLayoutSection(group: group)
            section.interGroupSpacing = UIConstant.collectionViewGroupSpacing
            
            section.contentInsets = UIConstant.collectionViewSectionContentInsets
            section.orthogonalScrollingBehavior = .continuous
            
            return section
        }
        
        return layout
    }
    
    func setupUI() {
        backgroundColor = UIColor(AppColor.primaryBackground)
        addSubview(collectionView)
        addSubview(separatorView)
        addSubview(tableView)

        setConstraints()
    }
    
    func setConstraints() {
        let collectionViewHeightAnchor = collectionView.heightAnchor.constraint(equalToConstant: UIConstant.collectionViewHeightAnchorConstant)
        collectionViewHeightAnchor.priority = .defaultHigh
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            collectionViewHeightAnchor,
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            separatorView.topAnchor.constraint(equalTo: collectionView.bottomAnchor),
            separatorView.widthAnchor.constraint(equalTo: widthAnchor),
            separatorView.heightAnchor.constraint(equalToConstant: UIConstant.separatorHeightAnchor),
            separatorView.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            tableView.topAnchor.constraint(equalTo: separatorView.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
}
