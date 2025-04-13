//
//  MoneyData.swift
//  YourMoneyApp
//
//  Created by 指原奈々 on 2025/03/02.
//

import Foundation
import RealmSwift

class MoneyData: Identifiable {
    var id: String = UUID().uuidString
    var price: Int
    var moneyType:MoneyType
    var incomeType: IncomeType?
    var expenseType: ExpenseType?
    var memo: String?
    var timestamp: Date
    
//    @Persisted(originProperty: "moneys") var owner: LinkingObjects<User>
    var userID: ObjectId?

    // サーバ同期用
    var isSynced: Bool = false
    var createdAt: Date = Date()
    var updatedAt: Date = Date()
    
    init(id:String = UUID().uuidString, price: Int, moneyType: MoneyType, incomeType: IncomeType? = nil, expenseType: ExpenseType? = nil, memo: String? = nil, timestamp: Date) {
        self.id = id
        self.price = price
        self.moneyType = moneyType
        self.incomeType = incomeType
        self.expenseType = expenseType
        self.memo = memo
        self.timestamp = timestamp
    }
    
    init() {
        self.price = 100
        self.moneyType = .income
        self.incomeType = .monthlyPayment
        self.expenseType = nil
        self.memo = "test"
        self.timestamp = Date()
    }
}
