//
//  SavingPlan.swift
//  CashBookForKidsApp
//
//  Created by 指原奈々 on 2025/04/14.
//


import Foundation
import RealmSwift

final class SavingPlan: Object, Identifiable {
    @Persisted(primaryKey: true) var id: String = UUID().uuidString
    @Persisted var isAchieved: Bool
    @Persisted var countDay: Int
    @Persisted var amount: Int
    @Persisted var timestamp: Date
    
    convenience init(id: String = UUID().uuidString,
                     isAchieved: Bool,
                     countDay: Int,
                     amount: Int,
                     timestamp: Date) {
        self.init()
        self.id = id
        self.isAchieved = isAchieved
        self.countDay = countDay
        self.amount = amount
        self.timestamp = timestamp
    }
}
