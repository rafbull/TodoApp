//
//  TodoDetailView.swift
//  ToDoApp
//
//  Created by Rafis on 26.06.2024.
//

import SwiftUI

struct TodoDetailView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    
    @StateObject var viewModel: TodoDetailViewModel
    @Binding var didTapSave: Bool
    @Binding var didTapDelete: Bool
    @State var textEditorText = ""
    @State var showAnimation = false
    
    @FocusState private var textEditorIsFocused: Bool
    @State private var keyboardHeight: CGFloat = 0
    
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
                            showAnimation: $showAnimation,
                            pickerSelection: $viewModel.todoItemImportanceNumber,
                            selectedDate: $viewModel.todoItemDeadline,
                            toggleIsOn: $viewModel.todoItemHasDeadline,
                            selectedColor: $viewModel.todoItemColor,
                            selectedHexColorValue: $viewModel.todoItemHexColorValue,
                            isDatePickerHidden: true
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
                        didTapSave.toggle()
                        dismiss()
                    }
                    .disabled(textEditorText.isEmpty)
                }
            }
        }
        // TODO: - tap gesture
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
            didTapDelete.toggle()
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
        TodoDetailView(viewModel: .init(todoItem: nil, dataService: DataService()), didTapSave: .constant(false), didTapDelete: .constant(false))
    }
}
