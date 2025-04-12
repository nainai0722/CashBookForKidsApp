//
//  Parent.swift
//  CashBookForKidsApp
//
//  Created by 指原奈々 on 2025/04/11.
//

import Foundation
import RealmSwift

class Parent: Object, Identifiable {
    @Persisted(primaryKey: true) var id: String = UUID().uuidString
    @Persisted var users = List<User>()
    @Persisted var timestamp: Date
}
