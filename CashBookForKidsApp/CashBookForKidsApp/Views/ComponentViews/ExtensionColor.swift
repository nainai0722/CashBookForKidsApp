//
//  ExtensionColor.swift
//  CashBookForKidsApp
//
//  Created by 指原奈々 on 2025/04/26.
//

import Foundation
import SwiftUI

extension Color {
    static func dynamic(light: Color, dark: Color) -> Color {
        return Color(UIColor { traitCollection in
            traitCollection.userInterfaceStyle == .dark ? UIColor(dark) : UIColor(light)
        })
    }
}

