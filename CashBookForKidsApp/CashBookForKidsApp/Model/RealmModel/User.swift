//
//  User.swift
//  CashBookForKidsApp
//
//  Created by 指原奈々 on 2025/04/11.
//

import Foundation
import RealmSwift

class User: Object,ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) var id: String = UUID().uuidString
    @Persisted var name: String
    @Persisted var moneys = List<Money>()
    
    // サーバ同期用
    @Persisted var lastSyncedAt: Date?
    @Persisted var createdAt: Date = Date()
    @Persisted var updatedAt: Date = Date()
    
    convenience init(id: String, name: String, moneys: List<Money> = List<Money>(), lastSyncedAt: Date? = nil, createdAt: Date, updatedAt: Date) {
        self.init()
        self.id = id
        self.name = name
        self.moneys = moneys
        self.lastSyncedAt = lastSyncedAt
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
    
    override init() {
        super .init()
        self.name = "テスト太郎"
//        self.moneys.append(Money())
        self.lastSyncedAt = Date()
        self.createdAt = Date()
        self.updatedAt = Date()
    }
}
