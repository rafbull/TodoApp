//
//  TodoCalendarTableViewCell.swift
//  ToDoApp
//
//  Created by Rafis on 02.07.2024.
//

import UIKit

final class TodoCalendarTableViewCell: UITableViewCell {
    static let identifier = String(describing: TodoCalendarTableViewCell.self)
    
    // MARK: - Private Constants
    private enum UIConstant {
        static let contentHStackViewSpacing: CGFloat = 16
    }
    
    // MARK: - Private Properties
    private let todoCategoryImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "circle.fill")
        imageView.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let todoTextLabel: UILabel = {
        let label = UILabel()
        label.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var contentHStackView: UIStackView = {
        let hStack = UIStackView(arrangedSubviews: [todoTextLabel, todoCategoryImageView])
        hStack.axis = .horizontal
        hStack.alignment = .center
        hStack.distribution = .fill
        hStack.spacing = UIConstant.contentHStackViewSpacing
        hStack.translatesAutoresizingMaskIntoConstraints = false
        return hStack
    }()
    
    // MARK: - Initialization
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Internal Methods    
    func setTodoTextLabel(text: NSAttributedString, isStrikethrough: Bool) {
        todoTextLabel.attributedText = text
        todoTextLabel.textColor = isStrikethrough ? UIColor(AppColor.tertiaryLabel) : UIColor(AppColor.primaryLabel)
    }
    
    func setTodoCategoryImage(color: UIColor) {
        todoCategoryImageView.tintColor = color
    }
}

// MARK: - Private Extension
private extension TodoCalendarTableViewCell {
    func setupUI() {
        contentView.addSubview(contentHStackView)
        
        setConstraints()
    }
    
    func setConstraints() {
        let contentMargin = contentView.layoutMarginsGuide
        
        let contentHStackViewWidthAnchor = contentHStackView.widthAnchor.constraint(equalTo: contentMargin.widthAnchor)
        contentHStackViewWidthAnchor.priority = .defaultHigh
        
        NSLayoutConstraint.activate([
            contentHStackView.topAnchor.constraint(equalToSystemSpacingBelow: contentMargin.topAnchor, multiplier: 1.0),
            contentHStackViewWidthAnchor,
            contentHStackView.centerXAnchor.constraint(equalTo: contentMargin.centerXAnchor),
            contentMargin.bottomAnchor.constraint(equalToSystemSpacingBelow: contentHStackView.bottomAnchor, multiplier: 1.0)
        ])
    }
}
