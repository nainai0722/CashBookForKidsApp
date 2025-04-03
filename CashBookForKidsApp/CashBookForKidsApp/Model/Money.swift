//
//  Money.swift
//  YourMoneyApp
//
//  Created by 指原奈々 on 2025/03/02.
//

import Foundation
import SwiftData

@Model
final class Money {
    var price: Int
    var moneyType:MoneyType
    var incomeType: IncomeType?
    var expenseType: ExpenseType?
    var memo: String?
    var timestamp: Date
    
    init(price: Int, moneyType: MoneyType, incomeType: IncomeType? = nil, expenseType: ExpenseType? = nil, memo: String? = nil, timestamp: Date) {
        self.price = price
        self.moneyType = moneyType
        self.incomeType = incomeType
        self.expenseType = expenseType
        self.memo = memo
        self.timestamp = timestamp
    }
}

enum MoneyType: String, CaseIterable, Codable {
    case income = "もらったお金"
    case expense = "使ったお金"
}

enum IncomeType: String, CaseIterable, Codable {
    case familySupport = "家族の手伝い"
    case study = "勉強"
    case monthlyPayment = "毎月のおこづかい"
    case other = "その他"
}

enum ExpenseType: String, CaseIterable, Codable {
    case game = "ゲーム"
    case food = "おやつ"
    case shopping = "お買い物"
    case other = "その他"
}
