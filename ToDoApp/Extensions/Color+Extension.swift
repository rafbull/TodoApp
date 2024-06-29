//
//  Color+Extension.swift
//  ToDoApp
//
//  Created by Rafis on 29.06.2024.
//

import SwiftUI

extension Color {
    static func convertFromHex(_ value: String) -> Color? {
        let hexString = value.hasPrefix("#") ? String(value.dropFirst(1)) : value
        guard let uIntValue = UInt64(hexString, radix: 16) else { return nil }
        return Color(
            red: Double((uIntValue & 0xFF0000) >> 16) / 255,
            green: Double((uIntValue & 0x00FF00) >> 8) / 255,
            blue: Double(uIntValue & 0x0000FF) / 255
        )
    }
}
