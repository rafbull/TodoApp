//
//  TodoListView.swift
//  ToDoApp
//
//  Created by Rafis on 21.06.2024.
//

import SwiftUI

struct TodoListView: View {
    // MARK: - Internal Properties
    @StateObject var viewModel: TodoListViewModel
    @State var showModalEmptyItem = false
    @State var showIsDoneItems = false
    @State var sortTodoItems = false
    @State var selectedTodoItem: TodoItem?
    @State var didTapSave = false
    @State var didTapDelete = false
    
    // MARK: - Private Constants
    private enum UIConstant {
        static let title = "Мои дела"
        static let newItemLeadingPadding: CGFloat = 40
        
        static let addTodoItemButtonSideSize: CGFloat = 24
        static let addTodoItemShadowRadius: CGFloat = 8
    }

    // MARK: - View body
    var body: some View {
        ZStack {
            mainNavigationView
            addTodoItemButton
                .frame(maxHeight: .infinity, alignment: .bottom)
                .sheet(isPresented: $showModalEmptyItem) {
                    TodoDetailView(
                        viewModel: TodoDetailViewModel(todoItem: nil, dataService: viewModel.dataService),
                        didTapSave: $didTapSave,
                        didTapDelete: $didTapDelete
                    )
                }
        }
        .onChange(of: [didTapSave, didTapDelete]) { _ in
            viewModel.viewIsOnAppear()
        }
    }
}

// MARK: - Private Extension
private extension TodoListView {
    // MARK: - Private Properties
    var todoItemsList: [TodoItem] {
        if showIsDoneItems {
            return sortTodoItems ? viewModel.todoItems : viewModel.sortedByImportance
        } else {
            return sortTodoItems ? viewModel.notDoneTodoItems : viewModel.sortedByImportance.filter { !$0.isDone }
        }
    }

    var mainNavigationView: some View {
        NavigationView {
            List {
                todoItemsSection
            }
            .navigationTitle(UIConstant.title)
            .onAppear {
                UITableView.appearance().backgroundColor = UIColor(AppColor.primaryBackground)
            }
            .animation(.easeInOut, value: showIsDoneItems)
        }
        .sheet(item: $selectedTodoItem) { item in
            TodoDetailView(
                viewModel: TodoDetailViewModel(todoItem: item, dataService: viewModel.dataService),
                didTapSave: $didTapSave,
                didTapDelete: $didTapDelete,
                textEditorText: item.text
            )
        }
    }

    var todoItemsSection: some View {
        Section {
            ForEach(todoItemsList) { todoItem in
                TodoListRowView(todoItem: todoItem)
                    .contentShape(Rectangle())
                    .onTapGesture {
                        selectedTodoItem = todoItem
                    }
                    .transition(.move(edge: .bottom))
                    .swipeActions(edge: .leading) {
                        createLeadingSwipeIsDoneButton(todoItem)
                    }
                    .swipeActions(edge: .trailing) {
                        createTrailingSwipeDeleteButton(todoItem)
                    }
                    .swipeActions(edge: .trailing) {
                        createTrailingSwipeInfoButton(todoItem)
                    }
            }
            Text("Новое")
                .font(AppFont.body)
                .foregroundColor(AppColor.tertiaryLabel)
                .padding(.vertical)
                .padding(.horizontal, UIConstant.newItemLeadingPadding)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                .contentShape(Rectangle())
                .onTapGesture {
                    showModalEmptyItem.toggle()
                }
        } header: {
            TodoListHeaderView(
                isDoneCount: viewModel.isDoneCount,
                showIsDoneItems: $showIsDoneItems,
                sortTodoItems: $sortTodoItems
            )
        }
    }

    var addTodoItemButton: some View {
        Button {
            showModalEmptyItem.toggle()
        } label: {
            Image(systemName: "plus")
                .resizable()
                .frame(
                    width: UIConstant.addTodoItemButtonSideSize,
                    height: UIConstant.addTodoItemButtonSideSize
                )
                .foregroundColor(AppColor.white)
                .padding()
                .background(AppColor.blue)
                .clipShape(Capsule())
                .shadow(radius: UIConstant.addTodoItemShadowRadius)
        }
    }

    // MARK: - Private Methods
    func createLeadingSwipeIsDoneButton(_ todoItem: TodoItem) -> some View {
        Button {
            viewModel.markAs(isDone: !todoItem.isDone, todoItem)
        } label: {
            Image(
                systemName: todoItem.isDone ? "circle" : "checkmark.circle.fill"
            )
        }
        .tint(todoItem.isDone ? AppColor.grayLight : AppColor.green)
    }

    func createTrailingSwipeDeleteButton(_ todoItem: TodoItem) -> some View {
        Button {
            viewModel.delete(todoItem)
        } label: {
            Image(systemName: "trash.fill")
        }
        .tint(AppColor.red)
    }

    func createTrailingSwipeInfoButton(_ todoItem: TodoItem) -> some View {
        Button {
            selectedTodoItem = todoItem
        } label: {
            Image(systemName: "info.circle.fill")
        }
        .tint(AppColor.grayLight)
    }
}

// MARK: - PreviewProvider
struct TodoListView_Previews: PreviewProvider {
    static var previews: some View {
        TodoListView(viewModel: TodoListViewModel(dataService: DataService()))
    }
}
