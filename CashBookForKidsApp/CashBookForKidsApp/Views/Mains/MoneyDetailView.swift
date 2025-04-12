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

struct MoneyDetailView: View {
    
    @State var moneyData: [MoneyType: [String: (count: Int, amount: Int)]] = [:]
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
        var  data: [PieChartData] = [
            PieChartData(category: IncomeType.familySupport.rawValue, value: Double(supportAmount)),
            PieChartData(category: IncomeType.monthlyPayment.rawValue, value: Double(monthlyPaymentAmount)),
            PieChartData(category: IncomeType.study.rawValue, value: Double(studyAmount)),
            PieChartData(category: IncomeType.other.rawValue, value: Double(otherAmount))
        ]
        return data
    }
    
    func getExpensePieData() -> [PieChartData]{
        var  data: [PieChartData] = [
            PieChartData(category: ExpenseType.food.rawValue, value: Double(foodAmount)),
            PieChartData(category: ExpenseType.game.rawValue, value: Double(gameAmount)),
            PieChartData(category: ExpenseType.shopping.rawValue, value: Double(shoppingAmount)),
            PieChartData(category: ExpenseType.other.rawValue, value: Double(otherExpenseAmount))
        ]
        return data
    }
    
    func fetchData() {
//        fetchTotalMoney()
//        fetchIncomeTypeData(incomeType: .study, incomeAmount: &studyAmount, incomeCount: &studyCount)
//        fetchIncomeTypeData(incomeType: .monthlyPayment, incomeAmount: &monthlyPaymentAmount, incomeCount: &monthlyPaymentCount)
//        fetchIncomeTypeData(incomeType: .familySupport, incomeAmount: &supportAmount, incomeCount: &supportCount)
//        fetchIncomeTypeData(incomeType: .other, incomeAmount: &otherAmount, incomeCount: &otherCount)
//        fetchFoodData()
//        fetchGameData()
//        fetchShoppingData()
//        fetchExpenseOtherData()
    }
    
    /// 🔹 **総額の計算**
//    private func fetchTotalMoney() {
//        let fetchDescriptor = FetchDescriptor<Money>()
//        if let allMoneys = try? modelContext.fetch(fetchDescriptor) {
//            let expense = allMoneys.filter { $0.moneyType == .expense }.reduce(0) { $0 + $1.price }
//            let income = allMoneys.filter { $0.moneyType == .income }.reduce(0) { $0 + $1.price }
//            totalMoney = income - expense
////            print("総額の再計算: \(totalMoney)")
//        }
//    }
    
//    private func fetchIncomeTypeData(incomeType:IncomeType, incomeAmount: inout Int, incomeCount: inout Int) {
//        let fetchDescriptor = FetchDescriptor<Money>()
//        if let allMoneys = try? modelContext.fetch(fetchDescriptor) {
//            incomeAmount = allMoneys.filter { $0.moneyType == .income && $0.incomeType == incomeType }.reduce(0) { $0 + $1.price }
//            incomeCount = allMoneys.filter { $0.moneyType == .income && $0.incomeType == incomeType }.count
//            print("fetchIncomeTypeData 処理")
//            print("\(incomeType.rawValue)の金額: \(incomeAmount)")
//            print("\(incomeType.rawValue)の回数: \(incomeCount)")
//        }
//    }
    
//    private func fetchSupportData() {
//        let fetchDescriptor = FetchDescriptor<Money>()
//        if let allMoneys = try? modelContext.fetch(fetchDescriptor) {
//            supportAmount = allMoneys.filter { $0.moneyType == .income && $0.incomeType == .familySupport }.reduce(0) { $0 + $1.price }
//            supportCount = allMoneys.filter { $0.moneyType == .income && $0.incomeType == .familySupport }.count
//            print("おてつだいの回数: \(supportCount)")
//        }
//    }
    
//    private func fetchMonthlyPaymentData() {
//        let fetchDescriptor = FetchDescriptor<Money>()
//        if let allMoneys = try? modelContext.fetch(fetchDescriptor) {
//            supportAmount = allMoneys.filter { $0.moneyType == .income && $0.incomeType == .monthlyPayment }.reduce(0) { $0 + $1.price }
//            supportCount = allMoneys.filter { $0.moneyType == .income && $0.incomeType == .monthlyPayment }.count
//            print("毎月のおこづかいの回数: \(supportCount)")
//        }
//    }
    
    
//    private func fetchStudyData() {
//        let fetchDescriptor = FetchDescriptor<Money>()
//        if let allMoneys = try? modelContext.fetch(fetchDescriptor) {
//            studyAmount = allMoneys.filter { $0.moneyType == .income && $0.incomeType == .study }.reduce(0) { $0 + $1.price }
//            studyCount = allMoneys.filter { $0.moneyType == .income && $0.incomeType == .study }.count
//            print("勉強の回数: \(studyCount)")
//        }
//    }
    
//    private func fetchOtherData() {
//        let fetchDescriptor = FetchDescriptor<Money>()
//        if let allMoneys = try? modelContext.fetch(fetchDescriptor) {
//            otherAmount = allMoneys.filter { $0.moneyType == .income && $0.incomeType == .other }.reduce(0) { $0 + $1.price }
//            otherCount = allMoneys.filter { $0.moneyType == .income && $0.incomeType == .other }.count
//            print("その他の回数: \(otherCount)")
//        }
//    }
    
//    private func fetchFoodData() {
//        let fetchDescriptor = FetchDescriptor<Money>()
//        if let allMoneys = try? modelContext.fetch(fetchDescriptor) {
//            foodAmount = allMoneys.filter { $0.moneyType == .expense && $0.expenseType == .food }.reduce(0) { $0 + $1.price }
//            foodCount = allMoneys.filter { $0.moneyType == .expense && $0.expenseType == .food }.count
//            print("おやつの回数: \(foodCount)")
//        }
//    }
    
//    private func fetchGameData() {
//        let fetchDescriptor = FetchDescriptor<Money>()
//        if let allMoneys = try? modelContext.fetch(fetchDescriptor) {
//            gameAmount = allMoneys.filter { $0.moneyType == .expense && $0.expenseType == .game }.reduce(0) { $0 + $1.price }
//            gameCount = allMoneys.filter { $0.moneyType == .expense && $0.expenseType == .game }.count
//            print("gameの回数: \(gameCount)")
//        }
//    }
    
//    private func fetchShoppingData() {
//        let fetchDescriptor = FetchDescriptor<Money>()
//        if let allMoneys = try? modelContext.fetch(fetchDescriptor) {
//            shoppingAmount = allMoneys.filter { $0.moneyType == .expense && $0.expenseType == .shopping }.reduce(0) { $0 + $1.price }
//            shoppingCount = allMoneys.filter { $0.moneyType == .expense && $0.expenseType == .shopping }.count
//            print("買い物の回数: \(shoppingCount)")
//        }
//    }
    
//    private func fetchExpenseOtherData() {
//        let fetchDescriptor = FetchDescriptor<Money>()
//        if let allMoneys = try? modelContext.fetch(fetchDescriptor) {
//            otherExpenseAmount = allMoneys.filter { $0.moneyType == .expense && $0.expenseType == .other }.reduce(0) { $0 + $1.price }
//            otherExpenseCount = allMoneys.filter { $0.moneyType == .expense && $0.expenseType == .other }.count
//            print("その他のの回数: \(foodCount)")
//        }
//    }
}

struct IncomePieChartView: View {
    var data: [PieChartData] = []

    var body: some View {
        Chart(data) { element in
            SectorMark(
                angle: .value("Value", element.value),
                innerRadius: .ratio(0.5),
                outerRadius: .ratio(1.0)
            )
            .foregroundStyle(by: .value("Category", element.category))
        }
        .frame(width: 200, height: 200)
    }
}


#Preview {
    MoneyDetailView()
}
