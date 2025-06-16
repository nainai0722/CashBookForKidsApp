//
//  Money.swift
//  YourMoneyApp
//
//  Created by 指原奈々 on 2025/03/02.
//

import Foundation
import RealmSwift

class Money: Object, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) var id: String = UUID().uuidString
    @Persisted var price: Int
    @Persisted var moneyType:MoneyType
    @Persisted var incomeType: IncomeType?
    @Persisted var expenseType: ExpenseType?
    @Persisted var memo: String?
    @Persisted var timestamp: Date
    
    @Persisted(originProperty: "moneys") var owner: LinkingObjects<User>

    @Persisted var userID: String
    
    // サーバ同期用
    @Persisted var isSynced: Bool = false
    @Persisted var createdAt: Date = Date()
    @Persisted var updatedAt: Date = Date()
    
    convenience init(id:String = UUID().uuidString, price: Int, moneyType: MoneyType, incomeType: IncomeType? = nil, expenseType: ExpenseType? = nil, memo: String? = nil, timestamp: Date, userID: String) {
        self.init()
        self.id = id
        self.price = price
        self.moneyType = moneyType
        self.incomeType = incomeType
        self.expenseType = expenseType
        self.memo = memo
        self.timestamp = timestamp
        self.userID = userID
    }
    
    override init() {
        self.price = 100
        self.moneyType = .income
        self.incomeType = .monthlyPayment
        self.expenseType = nil
        self.memo = "test"
        self.timestamp = Date()
    }
}

enum MoneyType: String, CaseIterable, Codable, PersistableEnum {
    case income = "もらったお金"
    case expense = "使ったお金"

    var localizedName: String {
        switch self {
        case .income:
            return NSLocalizedString("money_type_income", comment: "")
        case .expense:
            return NSLocalizedString("money_type_expense", comment: "")
        }
    }
}

enum IncomeType: String, CaseIterable, Codable, PersistableEnum {
    case familySupport = "家族の手伝い"
    case study = "勉強"
    case monthlyPayment = "毎月のおこづかい"
    case other = "その他"
    
    var localizedName: String {
        switch self {
        case .familySupport: return NSLocalizedString("income_family_support", comment: "")
        case .study: return NSLocalizedString("income_study", comment: "")
        case .monthlyPayment: return NSLocalizedString("income_monthly_payment", comment: "")
        case .other: return NSLocalizedString("income_other", comment: "")
        }
    }
    
}

enum ExpenseType: String, CaseIterable, Codable, PersistableEnum {
    case game = "ゲーム"
    case food = "おやつ"
    case shopping = "お買い物"
    case other = "その他"
    
    var localizedName: String {
        switch self {
        case .game: return NSLocalizedString("expense_game", comment: "")
        case .food: return NSLocalizedString("expense_food", comment: "")
        case .shopping: return NSLocalizedString("expense_shopping", comment: "")
        case .other: return NSLocalizedString("expense_other", comment: "")
        }
    }
}
