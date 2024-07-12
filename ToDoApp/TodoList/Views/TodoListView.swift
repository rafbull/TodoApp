//
//  TodoListView.swift
//  ToDoApp
//
//  Created by Rafis on 21.06.2024.
//

import SwiftUI
import CocoaLumberjackSwift

struct TodoListView: View {
    // MARK: - Internal Properties
    @StateObject var viewModel: TodoListViewModel
    @State private var showModalEmptyItem = false
    @State private var showIsDoneItems = false
    @State private var sortTodoItems = true
    @State private var selectedTodoItem: TodoItem?
    @State private var didTapCheckBoxButton = false
    @State private var textFieldText = ""
    
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
                        viewModel: TodoDetailViewModel(todoItem: nil, dataService: viewModel.dataService)
                    )
                }
        }
        .onAppear {
            DDLogInfo("File: \(#fileID) Function: \(#function)\n\tTodoListView Appears")
        }
        .onDisappear {
            DDLogInfo("File: \(#fileID) Function: \(#function)\n\tTodoListView Disappear")
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
            .navigationBarItems(leading: showCalendarButton)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    networkStartTest
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    networkCancelTest
                }
            }
            .onAppear {
                UITableView.appearance().backgroundColor = UIColor(AppColor.primaryBackground)
            }
            .animation(.easeInOut, value: showIsDoneItems)
        }
        .navigationViewStyle(.stack)
        .sheet(item: $selectedTodoItem) { item in
            TodoDetailView(
                viewModel: TodoDetailViewModel(todoItem: item, dataService: viewModel.dataService),
                textEditorText: item.text
            )
        }
    }

    var todoItemsSection: some View {
        Section {
            ForEach(todoItemsList) { todoItem in
                TodoListRowView(todoItem: todoItem, viewModel: viewModel)
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
            TextField(text: $textFieldText) {
                Text("Новое")
                    .font(AppFont.body)
                    .foregroundColor(AppColor.tertiaryLabel)
            }
            .submitLabel(.done)
            .onSubmit {
                guard !textFieldText.isEmpty else { return }
                viewModel.addNewItem(with: textFieldText)
                textFieldText = ""
            }
            .padding(.vertical)
            .padding(.horizontal, UIConstant.newItemLeadingPadding)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
            .contentShape(Rectangle())
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
    
    var showCalendarButton: some View {
        NavigationLink {
            TodoCalendarViewControllerRepresentable(dataService: viewModel.dataService)
                .ignoresSafeArea()
                .navigationBarTitleDisplayMode(.inline)
                .navigationTitle(UIConstant.title)
        } label: {
            Image(systemName: "calendar")
        }
    }
    
    var networkStartTest: some View {
        Button {
            viewModel.startTask()
        } label: {
            Image(systemName: "play")
        }
    }
    
    var networkCancelTest: some View {
        Button {
            viewModel.cancelTask()
        } label: {
            Image(systemName: "stop")
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
        TodoListView(viewModel: TodoListViewModel(
            dataService: DataService(),
            networkService: NetworkService()
        ))
    }
}
