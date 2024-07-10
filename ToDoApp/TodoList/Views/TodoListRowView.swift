//
//  TodoListRowView.swift
//  ToDoApp
//
//  Created by Rafis on 26.06.2024.
//

import SwiftUI

struct TodoListRowView: View {
    // MARK: - Internal Properties
    let todoItem: TodoItem
    let viewModel: TodoListViewModel
    
    // MARK: - Private Constants
    private enum UIConstant {
        static let todoItemImageSideSize: CGFloat = 24
        static let todoItemColorFrameWidth: CGFloat = 2
        static let todoItemTextLineLimit = 3
        
        static let hStackSpacing: CGFloat = 8
        static let deadLineHStackSpacing: CGFloat = 4
    }
    
    // MARK: - View body
    var body: some View {
        HStack(spacing: UIConstant.hStackSpacing) {
            Button {
                viewModel.markAs(isDone: !todoItem.isDone, todoItem)
            } label: {
                Image(systemName: todoItem.isDone ? "checkmark.circle" : "circle")
                    .resizable()
                    .frame(width: UIConstant.todoItemImageSideSize, height: UIConstant.todoItemImageSideSize)
                    .foregroundColor(
                        todoItem.isDone ?
                        AppColor.green : (todoItem.importance == .important) ?
                        AppColor.red : AppColor.separatorSupport
                    )
            }
            .buttonStyle(.borderless)
            
            Rectangle()
                .fill(Color.convertFromHex(todoItem.hexColor) ?? AppColor.secondaryBackground)
                .frame(width: UIConstant.todoItemColorFrameWidth)
            VStack(alignment: .leading) {
                Text(todoItem.importance == .important ? "‼️" + todoItem.text : todoItem.text)
                    .strikethrough(todoItem.isDone ? true : false)
                    .font(AppFont.body)
                    .lineLimit(UIConstant.todoItemTextLineLimit)
                    .foregroundColor(todoItem.isDone ? AppColor.tertiaryLabel : AppColor.primaryLabel)
                HStack(spacing: UIConstant.deadLineHStackSpacing) {
                    if let deadline = todoItem.deadline {
                        Image(systemName: "calendar")
                            .font(AppFont.subhead)
                            .foregroundColor(AppColor.tertiaryLabel)
                        Text(deadline, style: .date)
                            .font(AppFont.subhead)
                            .foregroundColor(AppColor.tertiaryLabel)
                    }
                    Spacer()
                }
            }
            Spacer()
            Image(systemName: "chevron.right")
                .foregroundColor(AppColor.gray)
        }   
    }
}

// MARK: - PreviewProvider
struct TodoListRowView_Previews: PreviewProvider {
    static let firstTodoItem = TodoItem(
        text: "First text",
        importance: .important,
        deadline: nil,
        isDone: true,
        modifyDate: nil,
        category: nil
    )
    static let secondTodoItem = TodoItem(
        text: "Second text",
        importance: .important,
        deadline: nil,
        isDone: false,
        modifyDate: nil,
        category: nil
    )
    
    static var previews: some View {
        Group {
            TodoListRowView(
                todoItem: firstTodoItem,
                viewModel: TodoListViewModel(dataService: DataService())
            )
            TodoListRowView(
                todoItem: secondTodoItem,
                viewModel: TodoListViewModel(dataService: DataService())
            )
        }
        .previewLayout(.sizeThatFits)
    }
}
