//
//  UIColor+Extension.swift
//  ToDoApp
//
//  Created by Rafis on 02.07.2024.
//

import UIKit

extension UIColor {
    static func convertFromHex(_ value: String, alpha: CGFloat) -> UIColor? {
        let hexString = value.hasPrefix("#") ? String(value.dropFirst(1)) : value
        guard let uIntValue = UInt64(hexString, radix: 16) else { return nil }
        return UIColor(
            red: CGFloat((uIntValue & 0xFF0000) >> 16) / 255,
            green: CGFloat((uIntValue & 0x00FF00) >> 8) / 255,
            blue: CGFloat(uIntValue & 0x0000FF) / 255,
            alpha: alpha
        )
    }
}
