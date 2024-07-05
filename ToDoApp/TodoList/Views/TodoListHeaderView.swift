//
//  TodoListHeaderView.swift
//  ToDoApp
//
//  Created by Rafis on 26.06.2024.
//

import SwiftUI

struct TodoListHeaderView: View {
    // MARK: - Internal Properties
    let isDoneCount: Int
    @Binding var showIsDoneItems: Bool
    @Binding var sortTodoItems: Bool
    
    // MARK: - View body
    var body: some View {
        HStack {
            Text("Выполнено - \(isDoneCount)")
            Spacer()
            Menu {
                Button(action: {
                    sortTodoItems.toggle()
                }) {
                    Text("Сортировка по добавлению/важности")
                }
                
                Button(action: {
                    showIsDoneItems.toggle()
                }) {
                    Text("Скрыть/показать выполненное")
                }
            } label: {
                Label("Фильтры", systemImage: "line.3.horizontal.decrease.circle")
            }
        }
        .textCase(nil)
    }
}

// MARK: - PreviewProvider
struct TodoListHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        TodoListHeaderView(
            isDoneCount: 3,
            showIsDoneItems: .constant(true),
            sortTodoItems: .constant(true)
        )
    }
}
