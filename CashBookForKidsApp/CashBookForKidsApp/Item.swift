//
//  Item.swift
//  CashBookForKidsApp
//
//  Created by 指原奈々 on 2025/04/03.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
