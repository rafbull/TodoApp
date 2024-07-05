//
//  TodoDetailSettingsSectionView.swift
//  ToDoApp
//
//  Created by Rafis on 27.06.2024.
//

import SwiftUI

struct TodoDetailSettingsSectionView: View {
    // MARK: - Internal Properties
    @StateObject var viewModel: TodoDetailViewModel
    @Binding var showAnimation: Bool

    // MARK: - Private Properties
    @State private var showColorPicker = false
    @State private var showCategory = false
    @State private var newCategoryName = ""
    @State private var showAddNewCategory = false
    @State private var showCategoryColorPicker = false
    @State private var isDatePickerHidden = true
    
    @State private var selectedCategoryColor = Color.white
    @State private var selectedCategoryHexColorValue = UIConstant.defaultCategoryHexColorValue
    
    // MARK: - Private Constants
    private enum UIConstant {
        static let importancePickerFrameWidth: CGFloat = 150
        static let colorPickerImageSideSize: CGFloat = 24
        static let colorPickerImageStrokeWidth: CGFloat = 1
        static let categoryPickerFrameHeight: CGFloat = 110
        static let defaultCategoryHexColorValue = "#FFFFFF"
    }

    // MARK: - View body
    var body: some View {
        importancePickerRowView
        colorPickerRowView
        if showColorPicker {
            SpectrumColorPickerView(selectedColor: $viewModel.todoItemColor, hexColorValue: $viewModel.todoItemHexColorValue)
        }
        categoryPickerView
        datePickerSection
            .animation(.easeInOut, value: showAnimation)
    }

    // MARK: - Private Views
    private var importancePickerRowView: some View {
        HStack {
            Text("Важность")
                .font(AppFont.body)
                .foregroundColor(AppColor.primaryLabel)
            Spacer()
            Picker("", selection: $viewModel.todoItemImportanceNumber) {
                Image(systemName: "arrow.down")
                    .tag(0)
                Text("нет")
                    .tag(1)
                Text("‼️")
                    .tag(2)
            }
            .pickerStyle(.segmented)
            .frame(width: UIConstant.importancePickerFrameWidth)
            .foregroundColor(AppColor.elevatedBackground)
        }
    }

    private var colorPickerRowView: some View {
        HStack {
            Text("Выбрать цвет")
                .font(AppFont.body)
                .foregroundColor(AppColor.primaryLabel)
            Spacer()
            Button(action: {
                showColorPicker.toggle()
            }, label: {
                Circle()
                    .fill(viewModel.todoItemColor)
                    .frame(
                        width: UIConstant.colorPickerImageSideSize,
                        height: UIConstant.colorPickerImageSideSize
                    )
                    .overlay(circleOverlayView)
            })
        }
    }

    private var categoryPickerView: some View {
        Group {
            HStack {
                Text("Выбрать категорию")
                    .font(AppFont.body)
                    .foregroundColor(AppColor.primaryLabel)
                Spacer()
                Button(action: {
                    showCategory.toggle()
                }, label: {
                    HStack {
                        Text(viewModel.todoItemCategory.name)
                            .font(AppFont.body)
                            .foregroundColor(AppColor.primaryLabel)
                        if let color = viewModel.todoItemCategory.hexColor {
                            Image(systemName: "circle.fill")
                                .foregroundColor(Color.convertFromHex(color))
                                .overlay(circleOverlayView)
                        }
                    }
                })
            }
            
            if showCategory {
                Picker("", selection: $viewModel.todoItemCategory) {
                    ForEach(viewModel.todoItemCategories) { category in
                        HStack {
                            Text(category.name)
                                .font(AppFont.body)
                                .foregroundColor(AppColor.primaryLabel)
                            Spacer()
                            if let color = category.hexColor {
                                Image(systemName: "circle.fill")
                                    .foregroundColor(Color.convertFromHex(color))
                                    .overlay(circleOverlayView)
                            }
                        }
                        .tag(category)
                    }
                }
                .pickerStyle(.wheel)
                .frame(height: UIConstant.categoryPickerFrameHeight)
                .clipped()
                Button("Добавить новую категорию") {
                    showAddNewCategory.toggle()
                }
                if showAddNewCategory {
                    HStack {
                        TextField(text: $newCategoryName) {
                            Text("Новая категория")
                                .font(AppFont.body)
                                .foregroundColor(AppColor.tertiaryLabel)
                        }
                        .submitLabel(.done)
                        .onSubmit {
                            viewModel.addNewTodoItemCategory(
                                with: newCategoryName,
                                and: selectedCategoryHexColorValue
                            )
                            newCategoryName = ""
                            showAddNewCategory.toggle()
                            showCategoryColorPicker.toggle()
                        }
                        Button(action: {
                            showCategoryColorPicker.toggle()
                        }, label: {
                            Circle()
                                .fill(selectedCategoryColor)
                                .frame(
                                    width: UIConstant.colorPickerImageSideSize,
                                    height: UIConstant.colorPickerImageSideSize
                                )
                                .overlay(circleOverlayView)
                        })
                    }
                }
                if showCategoryColorPicker {
                    SpectrumColorPickerView(
                        selectedColor: $selectedCategoryColor,
                        hexColorValue: $selectedCategoryHexColorValue
                    )
                }
            }
        }
    }
    
    private var datePickerSection: some View {
        Group {
            HStack {
                VStack(alignment: .leading) {
                    Text("Сделать до")
                        .font(AppFont.body)
                        .foregroundColor(AppColor.primaryLabel)
                    if viewModel.todoItemHasDeadline {
                        Text(viewModel.todoItemDeadline.formatted(date: .abbreviated, time: .omitted))
                            .font(AppFont.footnote)
                            .foregroundColor(Color.accentColor)
                            .onTapGesture {
                                isDatePickerHidden.toggle()
                                showAnimation.toggle()
                            }
                    }
                }
                Spacer()
                Toggle("", isOn: $viewModel.todoItemHasDeadline)
            }
            if !isDatePickerHidden && viewModel.todoItemHasDeadline {
                DatePicker("", selection: $viewModel.todoItemDeadline, in: .now..., displayedComponents: .date)
                    .datePickerStyle(.graphical)
                    .transition(.move(edge: .top))
            }
        }
    }
    
    private var circleOverlayView: some View {
        Circle()
            .stroke(
                AppColor.separatorSupport,
                lineWidth: UIConstant.colorPickerImageStrokeWidth
            )
    }
}

// MARK: - PreviewProvider
struct TodoDetailSettingsSectionView_Previews: PreviewProvider {
    static var previews: some View {
        TodoDetailSettingsSectionView(
            viewModel: .init(todoItem: nil, dataService: DataService()),
            showAnimation: .constant(true)
        )
    }
}
