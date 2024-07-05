//
//  TodoDetailView.swift
//  ToDoApp
//
//  Created by Rafis on 26.06.2024.
//

import SwiftUI

struct TodoDetailView: View {
    // MARK: - Internal Properties
    @StateObject var viewModel: TodoDetailViewModel
    @State var textEditorText = ""
    
    // MARK: - Private Properties
    @Environment(\.dismiss) private var dismiss
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @FocusState private var textEditorIsFocused: Bool
    @State private var keyboardHeight: CGFloat = 0
    @State private var showAnimation = false
    
    // MARK: - Private Constants
    private enum UIConstant {
        static let title = "Дело"
        static let placeholder = "Что надо сделать?"
        static let cornerRadius: CGFloat = 16
        static let colorFrameWidth: CGFloat = 2
        static let textEditorMinHeight: CGFloat = 120
        static let placeholderPadding: CGFloat = 8
    }
    
    // MARK: - View body
    var body: some View {
        NavigationView {
            List {
                Section {
                    textEditorWithPlaceHolder
                        .overlay(alignment: .trailing) {
                            Rectangle()
                                .fill(viewModel.todoItemColor)
                                .frame(width: UIConstant.colorFrameWidth)
                        }
                }
                if horizontalSizeClass == .compact {
                    Section {
                        TodoDetailSettingsSectionView(
                            viewModel: viewModel,
                            showAnimation: $showAnimation
                        )
                    }
                    Section {
                        deleteTodoItemButton
                    }
                }
            }
            .animation(.easeInOut, value: showAnimation)
            .background(AppColor.primaryBackground)
            .navigationTitle(UIConstant.title)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Отменить") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Сохранить") {
                        viewModel.updateItem(with: textEditorText, modifyDate: .now)
                        dismiss()
                    }
                    .disabled(textEditorText.isEmpty)
                }
            }
        }
        // TODO: - tap gesture to close keyboard
//        .simultaneousGesture(
//            TapGesture()
//                .onEnded { _ in
//                    textEditorIsFocused = false
//                }
//        )
        .onAppear {
            addKeyboardNotification()
        }
        .onDisappear {
            removeKeyboardNotification()
        }
    }
    
    // MARK: - Private Properies
    private var textEditorWithPlaceHolder: some View {
        ZStack(alignment: .topLeading) {
            TextEditor(text: $textEditorText)
                .focused($textEditorIsFocused)
                .frame(minHeight: UIConstant.textEditorMinHeight)
            if textEditorText.isEmpty {
                Text(UIConstant.placeholder)
                    .foregroundColor(Color(.placeholderText))
                    .padding(.horizontal, UIConstant.placeholderPadding)
                    .padding(.vertical, UIConstant.placeholderPadding)
            }
        }
    }
    
    private var deleteTodoItemButton: some View {
        Button("Удалить") {
            viewModel.deleteTodoItem()
            dismiss()
        }
        .padding()
        .frame(maxWidth: .infinity)
        .foregroundColor(textEditorText.isEmpty ? AppColor.tertiaryLabel : AppColor.red)
        .disabled(textEditorText.isEmpty)
    }

    
}

// MARK: - Private Extension
private extension TodoDetailView {
    func addKeyboardNotification() {
        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: .main) { (notification) in
            if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
                if let window = UIApplication.shared.connectedScenes
                    .compactMap({ $0 as? UIWindowScene })
                    .first?.windows
                    .first {
                    keyboardHeight = keyboardFrame.height - window.safeAreaInsets.bottom
                }
            }
        }
        
        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: .main) { _ in
            keyboardHeight = 0
        }
    }
    
    func removeKeyboardNotification() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
}

// MARK: - PreviewProvider
struct TodoDetailView_Previews: PreviewProvider {
    static var previews: some View {
        TodoDetailView(
            viewModel: .init(todoItem: nil, dataService: DataService())
        )
    }
}
