//
//  MoneyDetailView.swift
//  YourMoneyApp
//
//  Created by 指原奈々 on 2025/03/09.
//

import SwiftUI
import RealmSwift
import Charts

struct PieChartData: Identifiable {
    let id = UUID()
    let category: String
    let value: Double
}

struct MoneyChartView: View {
    @ObservedRealmObject var user: User
    
    @State var incomeTypeTotals: [String: Int] = [:]
    @State var expenseTypeTotals: [String: Int] = [:]
    @State var totalMoney:Int = 0
    @State var supportCount = 0
    @State var supportAmount = 0
    @State var monthlyPaymentCount = 0
    @State var monthlyPaymentAmount = 0
    @State var studyCount = 0
    @State var studyAmount = 0
    @State var otherCount = 0
    @State var otherAmount = 0
    @State var foodCount = 0
    @State var foodAmount = 0
    @State var gameCount = 0
    @State var gameAmount = 0
    @State var shoppingCount = 0
    @State var shoppingAmount = 0
    @State var otherExpenseCount = 0
    @State var otherExpenseAmount = 0
    
    func fetchIncomeTypeTotals() {
        let allIncomes = Set(user.moneys.map { $0.incomeType })
        
        print("お金があるか？\(user.moneys.count)" )
        for money in user.moneys {
            print(money.price)
        }
        
        for income in allIncomes {
            let total = user.moneys
                .where { $0.incomeType == income && $0.moneyType == .income }
                .sum(of: \.price)
            incomeTypeTotals[income?.rawValue ?? ""] = total
        }
    }
    
    func fetchExpenseTypeTotals() {
        let allExpenses = Set(user.moneys.map { $0.expenseType })

        for expense in allExpenses {
            let total = user.moneys
                .where { $0.expenseType == expense && $0.moneyType == .expense }
                .sum(of: \.price)
            expenseTypeTotals[expense?.rawValue ?? ""] = total
        }
    }
    
    var body: some View {
        VStack {
            ZStack {
                Rectangle().fill(Color.white)
                    .cornerRadius(20)
                    .padding()
                VStack() {
                    Text("もらったお金の内訳")
                    if existIncomeData() == false {
                        Text("収入はありません")
                    } else {
                        IncomePieChartView(data: getIncomePieData())
                    }
                }
                
            }
            ZStack {
                Rectangle().fill(Color.white)
                    .cornerRadius(20)
                    .padding()
                VStack {
                    Text("つかったお金の内訳")
                    if existExpenseData() == false{
                        Text("支出はありません")
                    } else {
                        IncomePieChartView(data: getExpensePieData())
                    }
                }
                
            }
        }
        .background(Color.gray.opacity(0.2))
        .onAppear {
            fetchData()
            fetchIncomeTypeTotals()
            fetchExpenseTypeTotals()
        }
    }
    
    func existIncomeData() -> Bool {
        if supportCount > 0 || monthlyPaymentCount > 0 || studyCount > 0 || otherCount > 0 {
            return true
        }
        return false
    }
    
    func existExpenseData() -> Bool {
        if foodCount > 0 || gameCount > 0 || shoppingCount > 0 || otherExpenseCount > 0 {
            return true
        }
        return false
    }
    
    func getIncomePieData() -> [PieChartData]{
        var chartData: [PieChartData] = []
        
        for (key, value) in incomeTypeTotals {
            chartData.append(PieChartData(category: key, value: Double(value)))
        }
        return chartData
    }
    
    func getExpensePieData() -> [PieChartData]{
        var chartData: [PieChartData] = []
        
        for (key, value) in expenseTypeTotals {
            chartData.append(PieChartData(category: key, value: Double(value)))
        }
        return chartData
    }
    
    func fetchData() {
        fetchTotalMoney()
        // もらった分の集計
        fetchIncomeTypeData(incomeType: .study, incomeAmount: &studyAmount, incomeCount: &studyCount)
        fetchIncomeTypeData(incomeType: .monthlyPayment, incomeAmount: &monthlyPaymentAmount, incomeCount: &monthlyPaymentCount)
        fetchIncomeTypeData(incomeType: .familySupport, incomeAmount: &supportAmount, incomeCount: &supportCount)
        fetchIncomeTypeData(incomeType: .other, incomeAmount: &otherAmount, incomeCount: &otherCount)
        // 使った分の集計
        fetchExpenseTypeData(expenseType: .food, expenseAmount: &foodAmount, expenseCount: &foodCount)
        fetchExpenseTypeData(expenseType: .other, expenseAmount: &otherExpenseAmount, expenseCount: &otherExpenseCount)
        fetchExpenseTypeData(expenseType:.game, expenseAmount: &gameAmount, expenseCount: &gameCount)
        fetchExpenseTypeData(expenseType: .shopping, expenseAmount: &shoppingAmount, expenseCount: &shoppingCount)
    }
    
    /// 🔹 **総額の計算**
    
    private func fetchTotalMoney() {
        let expenseTotal = user.moneys
            .where { $0.moneyType == .expense }
            .sum(of: \.price)

        let incomeTotal = user.moneys
            .where { $0.moneyType == .income }
            .sum(of: \.price)

        totalMoney = incomeTotal - expenseTotal
    }

    
    private func fetchIncomeTypeData(incomeType:IncomeType, incomeAmount: inout Int, incomeCount: inout Int) {
        
        incomeAmount = user.moneys
            .where { $0.moneyType == .income && $0.incomeType == incomeType }
            .sum(of: \.price)
        incomeCount = user.moneys
            .where { $0.moneyType == .income && $0.incomeType == incomeType }.count
        print("\(incomeType.rawValue)の金額: \(incomeAmount)")
        print("\(incomeType.rawValue)の回数: \(incomeCount)")
    }
    
    private func fetchExpenseTypeData(expenseType:ExpenseType, expenseAmount: inout Int, expenseCount: inout Int) {
        
        expenseAmount = user.moneys
            .where { $0.moneyType == .expense && $0.expenseType == expenseType }
            .sum(of: \.price)
        expenseCount = user.moneys
            .where { $0.moneyType == .expense && $0.expenseType == expenseType }.count
        print("\(expenseType.rawValue)の金額: \(expenseAmount)")
        print("\(expenseType.rawValue)の回数: \(expenseCount)")
    }
}

struct IncomePieChartView: View {
    var data: [PieChartData] = []

    var body: some View {

        Chart(data) { element in
            if #available(iOS 17.0, *) {
                SectorMark(
                    angle: .value("Value", element.value),
                    innerRadius: .ratio(0.5),
                    outerRadius: .ratio(1.0)
                )
                .foregroundStyle(by: .value("Category", element.category))
            } else {
                // Fallback on earlier versions
            }
        }
        .frame(width: 200, height: 200)
        .onAppear() {
            print("チャート画面呼び出し")
            print(data.count)
            for i in data {
                print(i.category)
                print(i.value)
            }
        }
    }
}

#Preview("テストユーザー") {
    PreviewProviderForMoneyChartView.preview
}

private struct PreviewProviderForMoneyChartView{
    static var preview: some View {
        let user = User()
        user.name = "プレビュー太郎"
        user.createdAt = Date()
        
        let money = Money()
        money.price = 1000
        money.moneyType = .income
        money.incomeType = .monthlyPayment
        money.memo = "月のおこづかい"
        money.timestamp = Date()
        
        let money2 = Money()
        money2.price = 300
        money2.moneyType = .expense
        money2.expenseType = .food
        money2.memo = "月のおこづかい"
        money2.timestamp = Date()
        
        let money3 = Money()
        money3.price = 300
        money3.moneyType = .expense
        money3.expenseType = .shopping
        money3.memo = "月のおこづかい"
        money3.timestamp = Date()
        
        user.moneys.append(money)
        user.moneys.append(money)
        user.moneys.append(money2)
        user.moneys.append(money3)
        
        let realm = try! Realm(configuration: Realm.Configuration(inMemoryIdentifier: "PreviewRealm"))
        try! realm.write {
            realm.add(user)
        }

        return MoneyChartView(user: user)
    }
}
