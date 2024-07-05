//
//  TodoCalendarViewController.swift
//  ToDoApp
//
//  Created by Rafis on 02.07.2024.
//

import UIKit
import Combine

final class TodoCalendarViewController: UIViewController {
    // MARK: - Private Properties
    private let viewModel: TodoCalendarViewModelProtocol
    private var collectionViewDataSorce: TodoCalendarCollectionViewDataSource?
    private var tableViewDataSource: TodoCalendarTableViewDataSource?
    private var subscriptions = Set<AnyCancellable>()
    private lazy var contentView: TodoCalendarView = {
        let contentView = TodoCalendarView()
        contentView.collectionView.delegate = self
        contentView.tableView.delegate = self
        return contentView
    }()
    
    // MARK: - Initialization
    init(viewModel: TodoCalendarViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - LifeCycle
    override func loadView() {
        view = contentView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDataSources()
        bindToViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
}

// MARK: - Extension UITableViewDelegate
extension TodoCalendarViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.didSelectRowAt(at: indexPath)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let indexPath = tableView.indexPathsForVisibleRows?.first  else { return }
        let topSection = indexPath.section == 0 ? indexPath.section : indexPath.section + 1
        viewModel.didEndDisplaying(for: topSection)
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .normal, title: nil) { [weak self] _, _, boolValue in
            self?.viewModel.didSwipe(at: indexPath, isLeading: true)
            self?.contentView.tableView.reloadRows(at: [indexPath], with: .automatic)
            boolValue(true)
        }
        action.image = UIImage(systemName: "checkmark.circle.fill")
        action.backgroundColor = UIColor(AppColor.green)
        return UISwipeActionsConfiguration(actions: [action])
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .normal, title: nil) { [weak self] _, _, boolValue in
            self?.viewModel.didSwipe(at: indexPath, isLeading: false)
            self?.contentView.tableView.reloadRows(at: [indexPath], with: .automatic)
            boolValue(true)
        }
        action.image = UIImage(systemName: "circle")
        action.backgroundColor = UIColor(AppColor.grayLight)
        return UISwipeActionsConfiguration(actions: [action])
    }
}

// MARK: - Extension UICollectionViewDelegate
extension TodoCalendarViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.collectionViewDidSelectItemAt(at: indexPath.item)
    }
}

// MARK: - Private Extension
private extension TodoCalendarViewController {
    func setupDataSources() {
        collectionViewDataSorce = TodoCalendarCollectionViewDataSource(viewModel)
        tableViewDataSource = TodoCalendarTableViewDataSource(viewModel)
        
        contentView.collectionView.dataSource = collectionViewDataSorce
        contentView.tableView.dataSource = tableViewDataSource
    }
    
    func bindToViewModel() {
        selectDateItem()
        dispalySection()
        
        viewModel.isDataChanged
            .sink { [weak self] _ in
                self?.contentView.tableView.reloadData()
                self?.contentView.collectionView.reloadData()
            }
            .store(in: &subscriptions)
    }
    
    func selectDateItem() {
        viewModel.dateSelectedIndex
            .sink { [weak self] index in
                self?.contentView.collectionView.selectItem(
                    at: .init(item: index, section: 0),
                    animated: true,
                    scrollPosition: .left
                )
            }
            .store(in: &subscriptions)
    }
    
    func dispalySection() {
        viewModel.displayingSectionIndex
            .sink { [weak self] index in
                self?.contentView.tableView.scrollToRow(
                    at: .init(row: 0, section: index),
                    at: .top,
                    animated: true
                )
            }
            .store(in: &subscriptions)
    }
}
