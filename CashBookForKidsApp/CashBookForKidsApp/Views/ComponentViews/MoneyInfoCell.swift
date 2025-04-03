//
//  MoneyInfoCell.swift
//  YourMoneyApp
//
//  Created by 指原奈々 on 2025/03/04.
//

import SwiftUI

struct MoneyInfoCell: View {
    var money :Money = Money(price: 0, moneyType: .income, incomeType: .familySupport, expenseType: nil, memo: "メモメモ", timestamp: Date())
    var body: some View {
        
        HStack {
            VStack(alignment: .leading) {
                Text(moneyContent(money: money))
                    .padding(.bottom, 10)
                    
                Text(money.timestamp.formattedString)
                    .font(.system(size: 20))
                    .foregroundStyle(.secondary)
            }
            Spacer()
            
            Text("\(money.moneyType == .income ? "+" : "-") \(money.price)円")
                .font(.system(size: 30))
        }
        .padding(.horizontal, 20)
    }
    
    func moneyContent(money:Money) -> String {
        var moneyContent : String = ""
        if (money.moneyType == .income) {
            if let incomeType = money.incomeType {
                moneyContent = incomeType.rawValue
            }
        } else {
            if let expenseType = money.expenseType {
                moneyContent = expenseType.rawValue
            }
        }
        return moneyContent
    }
    
}

#Preview {
    MoneyInfoCell()
}
