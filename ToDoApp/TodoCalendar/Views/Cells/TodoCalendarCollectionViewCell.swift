//
//  TodoCalendarCollectionViewCell.swift
//  ToDoApp
//
//  Created by Rafis on 03.07.2024.
//

import UIKit

final class TodoCalendarCollectionViewCell: UICollectionViewCell {
    static let identifier = String(describing: TodoCalendarCollectionViewCell.self)
    
    // MARK: - Private Constants
    private enum UIConstant {
        static let contentVStackViewSpacing: CGFloat = 8
        static let cornerRadius: CGFloat = 10
        static let borderWidth: CGFloat = 2
    }
    
    // MARK: - Private Properties
    private let dateNumberLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = UIColor(AppColor.secondaryLabel)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let dateTextLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = UIColor(AppColor.secondaryLabel)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var contentVStackView: UIStackView = {
        let vStack = UIStackView(arrangedSubviews: [dateNumberLabel, dateTextLabel])
        vStack.axis = .vertical
        vStack.alignment = .center
        vStack.distribution = .fill
        vStack.spacing = UIConstant.contentVStackViewSpacing
        vStack.translatesAutoresizingMaskIntoConstraints = false
        return vStack
    }()
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Internal Methods
    func setDateNumberLabel(text: String?) {
        dateNumberLabel.text = text
    }
    
    func setDateTextLabel(text: String?) {
        dateTextLabel.text = text
    }
}

// MARK: - Private Extension
private extension TodoCalendarCollectionViewCell {
    func setupUI() {
        layer.cornerRadius = UIConstant.cornerRadius
        layer.masksToBounds = true
        contentView.addSubview(contentVStackView)
        setConstraints()
        setupSelectionView()
    }
    
    func setupSelectionView() {
        let selectionView = UIView(frame: bounds)
        selectionView.layer.borderColor = UIColor(AppColor.secondaryLabel).cgColor
        selectionView.layer.borderWidth = UIConstant.borderWidth
        selectionView.layer.cornerRadius = UIConstant.cornerRadius
        selectionView.backgroundColor = UIColor(AppColor.overlaySupport)
        selectedBackgroundView = selectionView
    }
    
    func setConstraints() {
        let contentMargin = contentView.layoutMarginsGuide
        
        NSLayoutConstraint.activate([
            contentVStackView.topAnchor.constraint(equalTo: contentMargin.topAnchor),
            contentVStackView.leadingAnchor.constraint(equalTo: contentMargin.leadingAnchor),
            contentVStackView.trailingAnchor.constraint(equalTo: contentMargin.trailingAnchor),
            contentVStackView.bottomAnchor.constraint(equalTo: contentMargin.bottomAnchor),
        ])
    }
}
