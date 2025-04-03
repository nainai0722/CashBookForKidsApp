//
//  Goal.swift
//  YourMoneyApp
//
//  Created by 指原奈々 on 2025/03/08.
//


import Foundation
import SwiftData

@Model
final class Goal {
    var id : UUID?
    var isAchieved: Bool
    var level: Int
    var amount: Int
    var goalType: String
    var timestamp: Date
    
    init(id: UUID? = nil, isAchieved: Bool, level: Int, amount: Int, goalType: String, timestamp: Date) {
        self.id = id
        self.isAchieved = isAchieved
        self.level = level
        self.amount = amount
        self.goalType = goalType
        self.timestamp = timestamp
    }
    
    static let mockGoal = Goal(id: UUID(), isAchieved:false,level: 1, amount: 1000, goalType: "貯金", timestamp: Date())
    
    static let mockGoalsList: [Goal] = [
        Goal(id: UUID(), isAchieved:false,level: 1, amount: 1000, goalType: "貯金", timestamp: Date()),
        Goal(id: UUID(), isAchieved:false,level: 2, amount: 1500, goalType: "貯金", timestamp: Date()),
        Goal(id: UUID(), isAchieved:false,level: 3, amount: 2000, goalType: "貯金", timestamp: Date()),
        Goal(id: UUID(), isAchieved:false,level: 4, amount: 3000, goalType: "貯金", timestamp: Date()),
        Goal(id: UUID(), isAchieved:false,level: 5, amount: 5000, goalType: "貯金", timestamp: Date()),
        ]
}

