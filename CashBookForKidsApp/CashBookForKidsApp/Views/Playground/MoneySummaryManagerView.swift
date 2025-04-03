//
//  MoneySummaryManagerView.swift
//  YourMoneyApp
//
//  Created by 指原奈々 on 2025/03/02.
//

import SwiftUI
import SwiftData

// Viewは検証用に扱う
struct MoneySummaryManagerView: View {
    @Query private var moneys: [Money]
//    let moneys: [Money] // ここで受け取る
    var body: some View {
        ZStack {
            Color(.systemGray6).ignoresSafeArea()
            
            VStack(alignment: .trailing, spacing :20){
                Text("持っているお金 : \(totalMoney)円")
                Text("もらったお金: \(incomeMoney)円")
                Text("使ったお金: \(expenseMoney)円")
                Text("おてつだいでもらったお金: \(familySupportMoney)")
                Text("おこづかいでもらったお金: \(monthlyPayment)")
                Text("2月にもらったお金: \(incomeMoneyByMonth(year: 2025, month: 02))")
                Text("3月にもらったお金: \(incomeMoneyByMonth(year: 2025, month: 03))")
            }
            .padding(20)
            .background(Color.white)
        }
    }
    
    // 計算プロパティ
    var totalMoney:Int{
        return incomeMoney - expenseMoney
    }
    
    // もらったお金の総額
    var incomeMoney: Int {
        let incomes = moneys.filter{ $0.moneyType == .income}.reduce(0) { $0+$1.price }
        return incomes
    }
    
    // お手伝いの総額
    var familySupportMoney: Int {
        let familySupportMoneys = moneys.filter{ $0.moneyType == .income && $0.incomeType == .familySupport }.reduce(0) { $0+$1.price }
        return familySupportMoneys
    }
    
    // 毎月のお小遣いの総額
    var monthlyPayment: Int {
        let monthlyPaymentMoneys = moneys.filter{ $0.moneyType == .income && $0.incomeType == .monthlyPayment }.reduce(0) { $0+$1.price }
        return monthlyPaymentMoneys
    }
    
    
    // その他でもらったお金の総額
    var otherIncomeMoney: Int {
        let otherIncomeMoneys = moneys.filter{ $0.moneyType == .income && $0.incomeType == .other }.reduce(0) { $0+$1.price }
        return otherIncomeMoneys
    }
    
    
    var expenseMoney: Int {
        let expense = moneys.filter{ $0.moneyType == .expense}.reduce(0) { $0+$1.price }
        return expense
    }
    
    
    // 指定したincomeTypeの総額
    func getIncomeTypeMoney(by incomeType:IncomeType) -> Int {
        let selectedIncomeTypeMoneys = moneys.filter{ $0.moneyType == .income && $0.incomeType == incomeType }.reduce(0){ $0+$1.price }
        return selectedIncomeTypeMoneys
    }
    
    func incomeMoneyByMonth(year: Int, month: Int) -> Int {
        let incomes = filterBy(year: year, month: month).filter{ $0.moneyType == .income}.reduce(0) { $0+$1.price }
        return incomes
    }
    
    func expenseMoneyByMonth(year: Int, month: Int) -> Int {
        let expense = filterBy(year: year, month: month).filter{ $0.moneyType == .expense }.reduce(0){ $0+$1.price }
        return expense
    }
    
    func filterBy(year: Int, month: Int) -> [Money] {
        let calendar = Calendar.current
        return moneys.filter {
            calendar.component(.year, from: $0.timestamp) == year &&
            calendar.component(.month, from: $0.timestamp) == month
        }
    }
}

#Preview {
    MoneySummaryManagerView()
        .modelContainer(for: Money.self)
}
