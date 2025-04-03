//
//  UserInfo.swift
//  YourMoneyApp
//
//  Created by 指原奈々 on 2025/03/08.
//

import Foundation
import SwiftData

@Model
final class UserInfo {
    var goal: Goal
    var timestamp: Date
    
    init(goal: Goal, timestamp: Date) {
        self.goal = goal
        self.timestamp = timestamp
    }
}
