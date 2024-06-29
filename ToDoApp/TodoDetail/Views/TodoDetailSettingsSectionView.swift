//
//  TodoDetailSettingsSectionView.swift
//  ToDoApp
//
//  Created by Rafis on 27.06.2024.
//

import SwiftUI

struct TodoDetailSettingsSectionView: View {
    @Binding var showAnimation: Bool
    @Binding var pickerSelection: Int
    @Binding var selectedDate: Date
    @Binding var toggleIsOn: Bool
    @Binding var selectedColor: Color
    @Binding var selectedHexColorValue: String
    @State var isDatePickerHidden: Bool
    @State var showColorPicker = false
    
    // MARK: - Private Constants
    private enum UIConstant {
        static let importancePickerFrameWidth: CGFloat = 150
        static let colorPickerImageSideSize: CGFloat = 24
        static let colorPickerImageStrokeWidth: CGFloat = 1
    }
    
    // MARK: - View body
    var body: some View {
        HStack {
            Text("Важность")
                .font(AppFont.body)
                .foregroundColor(AppColor.primaryLabel)
            Spacer()
            
            Picker("", selection: $pickerSelection) {
                Image(systemName: "arrow.down")
                    .tag(0)
                Text("нет")
                    .tag(1)
                Text("‼️")
                    .tag(2)
            }
            .pickerStyle(SegmentedPickerStyle())
            .frame(width: UIConstant.importancePickerFrameWidth)
            .foregroundColor(AppColor.elevatedBackground)
        }
        HStack {
            Text("Выбрать цвет")
                .font(AppFont.body)
                .foregroundColor(AppColor.primaryLabel)
            Spacer()
            Button(action: {
                showColorPicker.toggle()
            }, label: {
                Circle()
                    .fill(selectedColor)
                    .frame(
                        width: UIConstant.colorPickerImageSideSize,
                        height: UIConstant.colorPickerImageSideSize
                    )
                    .overlay(
                        Circle()
                            .stroke(
                                AppColor.separatorSupport,
                                lineWidth: UIConstant.colorPickerImageStrokeWidth
                            )
                    )
            })
        }
        if showColorPicker {
            SpectrumColorPickerView(selectedColor: $selectedColor, hexColorValue: $selectedHexColorValue)
        }
        Group {
            HStack {
                VStack(alignment: .leading) {
                    Text("Сделать до")
                        .font(AppFont.body)
                        .foregroundColor(AppColor.primaryLabel)
                    if toggleIsOn {
                        Text(selectedDate.formatted(date: .abbreviated, time: .omitted))
                            .font(AppFont.footnote)
                            .foregroundColor(Color.accentColor)
                            .onTapGesture {
                                isDatePickerHidden.toggle()
                                showAnimation.toggle()
                            }
                    }
                }
                Spacer()
                Toggle("", isOn: $toggleIsOn)
            }
            
            if !isDatePickerHidden && toggleIsOn {
                DatePicker("", selection: $selectedDate, in: .now..., displayedComponents: .date)
                    .datePickerStyle(.graphical)
                    .transition(.move(edge: .top))
            }
        }
        .animation(.easeInOut, value: showAnimation)
    }
}

// MARK: - PreviewProvider
struct TodoDetailSettingsSectionView_Previews: PreviewProvider {
    static var previews: some View {
        TodoDetailSettingsSectionView(
            showAnimation: .constant(true),
            pickerSelection: .constant(0),
            selectedDate: .constant(.now),
            toggleIsOn: .constant(true),
            selectedColor: .constant(.red),
            selectedHexColorValue: .constant("#FFFFFF"),
            isDatePickerHidden: true
        )
    }
}
