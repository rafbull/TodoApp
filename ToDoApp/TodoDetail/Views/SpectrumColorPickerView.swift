//
//  SpectrumColorPickerView.swift
//  ToDoApp
//
//  Created by Rafis on 29.06.2024.
//

import SwiftUI

struct SpectrumColorPickerView: View {
    // MARK: - Internal Properties
    @Binding var selectedColor: Color
    @Binding var hexColorValue: String
    
    // MARK: - Private Properties
    @State private var size: CGSize = .zero
    @State private var brightness: Double = 1.0
    
    // MARK: - Private Constants
    private enum UIConstant {
        static let cornerRadius: CGFloat = 16
    }
    
    // MARK: - View body
    var body: some View {
        VStack {
            HStack {
                Text(hexColorValue)
                    .font(AppFont.headline)
                Spacer()
            }
            
            HStack {
                let width: CGFloat = size.width
                let height: CGFloat = size.width / 2
                
                LinearGradient(gradient: Gradient(colors: [
                    Color(hue: 0, saturation: 1, brightness: brightness),
                    Color(hue: 1/6, saturation: 1, brightness: brightness),
                    Color(hue: 2/6, saturation: 1, brightness: brightness),
                    Color(hue: 3/6, saturation: 1, brightness: brightness),
                    Color(hue: 4/6, saturation: 1, brightness: brightness),
                    Color(hue: 5/6, saturation: 1, brightness: brightness),
                    Color(hue: 1, saturation: 1, brightness: brightness)
                ]), startPoint: .leading, endPoint: .trailing)
                .frame(width: width, height: height)
                .cornerRadius(UIConstant.cornerRadius)
                .overlay(
                    Rectangle()
                        .fill(LinearGradient(
                            gradient: Gradient(colors: [.black.opacity(0), .black.opacity(1)]),
                            startPoint: .top, endPoint: .bottom)
                        )
                        .cornerRadius(UIConstant.cornerRadius)
                )
                .gesture(DragGesture(minimumDistance: 0)
                    .onChanged { value in
                        updateColor(for: value, width: width, height: height)
                    }
                )
            }
            
            HStack {
                Image(systemName: "sun.min")
                Slider(value: $brightness, in: 0...1)
                    .onChange(of: brightness) { _ in
                        updateHexColorValue()
                    }
                Image(systemName: "sun.max")
            }
            .padding(.vertical)
            
            RoundedRectangle(cornerRadius: UIConstant.cornerRadius)
                .fill(selectedColor)
                .frame(height: size.width / 6)
                .overlay(
                    RoundedRectangle(cornerRadius: UIConstant.cornerRadius)
                        .stroke(AppColor.separatorSupport, lineWidth: 1)
                )
        }
        
        GeometryReader { proxy in
            HStack {}
                .onAppear {
                    size = proxy.size
                }
        }
    }
}

// MARK: - Private Extension
private extension SpectrumColorPickerView {
    func updateColor(for value: DragGesture.Value, width: CGFloat, height: CGFloat) {
        let hue = min(max(0, value.location.x / width), 1)
        let saturation = min(max(0, 1 - value.location.y / height), 1)
        selectedColor = Color(hue: hue, saturation: saturation, brightness: CGFloat(brightness))
        updateHexColorValue()
    }
    
    func updateHexColorValue() {
        hexColorValue = hexString(for: selectedColor)
    }
    
    func hexString(for color: Color) -> String {
        let components = color.cgColor?.components
        let r = Int((components?[0] ?? 0) * 255)
        let g = Int((components?[1] ?? 0) * 255)
        let b = Int((components?[2] ?? 0) * 255)
        let a = Int((components?[3] ?? 1) * 255)
        
        let convertedValue: String
        
        if a == 255 {
            convertedValue = String(format: "#%02X%02X%02X", r, g, b)
        } else {
            convertedValue = String(format: "#%02X%02X%02X%02X", r, g, b, a)
        }
        return convertedValue
    }
}
