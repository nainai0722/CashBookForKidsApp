//
//  User.swift
//  CashBookForKidsApp
//
//  Created by 指原奈々 on 2025/04/11.
//

import Foundation
import RealmSwift

class User: Object,Identifiable {
    @Persisted(primaryKey: true) var id: String = UUID().uuidString
    @Persisted var name: String
    @Persisted var moneys = List<Money>()
    
    // サーバ同期用
    @Persisted var lastSyncedAt: Date?
    @Persisted var createdAt: Date = Date()
    @Persisted var updatedAt: Date = Date()
}
