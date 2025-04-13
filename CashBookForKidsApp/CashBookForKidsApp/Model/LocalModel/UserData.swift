//
//  UserData.swift
//  CashBookForKidsApp
//
//  Created by 指原奈々 on 2025/04/11.
//

import Foundation
import RealmSwift

class UserData: Identifiable {
    var id: String = UUID().uuidString
    var name: String
    var moneys: [MoneyData]
    
    // サーバ同期用
    var lastSyncedAt: Date?
    var createdAt: Date = Date()
    var updatedAt: Date = Date()
    
    init(id: String, name: String, moneys: [MoneyData] = [], lastSyncedAt: Date? = nil, createdAt: Date, updatedAt: Date) {
        self.id = id
        self.name = name
        self.moneys = moneys
        self.lastSyncedAt = lastSyncedAt
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
    init() {
        self.id = "11111"
        self.name = "ゆーざー"
        self.moneys = []
        self.lastSyncedAt = Date()
        self.createdAt = Date()
        self.updatedAt = Date()
    }
}
