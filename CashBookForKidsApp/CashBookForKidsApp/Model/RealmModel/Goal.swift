//
//  Goal.swift
//  YourMoneyApp
//
//  Created by 指原奈々 on 2025/03/08.
//


import Foundation
import RealmSwift

final class Goal: Object, Identifiable {
    @Persisted(primaryKey: true) var id: String = UUID().uuidString
    @Persisted var isAchieved: Bool
    @Persisted var level: Int
    @Persisted var amount: Int
    @Persisted var goalType: String
    @Persisted var timestamp: Date
    
    convenience init(id: String = UUID().uuidString,
                     isAchieved: Bool,
                     level: Int,
                     amount: Int,
                     goalType: String,
                     timestamp: Date) {
        self.init()
        self.id = id
        self.isAchieved = isAchieved
        self.level = level
        self.amount = amount
        self.goalType = goalType
        self.timestamp = timestamp
    }
}

