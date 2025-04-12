//
//  UserInfo.swift
//  YourMoneyApp
//
//  Created by 指原奈々 on 2025/03/08.
//

import Foundation
//import SwiftData
import RealmSwift

class UserInfo: Object, Identifiable {
    @Persisted(primaryKey: true) var id: String = UUID().uuidString
    @Persisted var goal: Goal?
    @Persisted var timestamp: Date
}
