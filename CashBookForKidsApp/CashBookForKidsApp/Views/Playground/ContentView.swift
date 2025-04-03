//
//  ContentView.swift
//  YourMoneyApp
//
//  Created by 指原奈々 on 2025/03/02.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var moneys: [Money]

    var body: some View {
        NavigationSplitView {
            
            MoneySummaryManagerView()
            
            List {
                ForEach(moneys) { money in
                    NavigationLink {
                        Text("Item at \(money.timestamp, format: Date.FormatStyle(date: .numeric, time: .standard))")
                    } label: {
                        MoneyInfoCell(money: money)
                    }
                }
                .onDelete(perform: deleteMoneys)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
                ToolbarItem {
                    Button(action: addMoney) {
                        Label("Add Money", systemImage: "plus")
                    }
                }
                ToolbarItem {
                    Button(action: addMoneyByDate) {
                        Label("Add Money By Date", systemImage: "plus")
                    }
                }
            }
        } detail: {
            Text("Select an money")
        }
    }

    private func addMoney() {
        withAnimation {
            let newItem = Money(price: 100, moneyType: .income, incomeType: .monthlyPayment, memo: "メモメモ", timestamp: Date())
            modelContext.insert(newItem)
        }
    }
    
    func addMoneyByDate() {
        let calendar = Calendar.current
        if let specificDate = calendar.date(from: DateComponents(year: 2025, month: 2, day: 1)) {
            addMoneyByDate(by: specificDate)
        }
    }
    
    private func addMoneyByDate(by date: Date) {
        withAnimation {
            
            let newItem = Money(price: 100, moneyType: .income, incomeType: .familySupport, memo: "メモメモ", timestamp: date)
            modelContext.insert(newItem)
        }
    }
    
    private func deleteMoneys(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(moneys[index])
            }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Money.self)
}

struct SampleMoneySummaryView: View {
    @Query private var moneys: [Money]
    var body: some View {
        VStack{
            Text("持っているお金 : \(totalMoney())円")
            HStack {
                Text("もらったお金: \(incomeMoney())円")
                Text("もらったお金: \(expenseMoney())円")
            }
        }
    }
    
    func totalMoney() -> String {
        let incomes = moneys.filter{ $0.moneyType == .income}.reduce(0) { $0+$1.price }
        let expense = moneys.filter{ $0.moneyType == .expense}.reduce(0) { $0+$1.price }
        let total = incomes - expense
        return String(total)
    }
    func incomeMoney() -> String {
        let incomes = moneys.filter{ $0.moneyType == .income}.reduce(0) { $0+$1.price }
        return String(incomes)
    }
    
    func expenseMoney() -> String {
        let expense = moneys.filter{ $0.moneyType == .expense}.reduce(0) { $0+$1.price }
        return String(expense)
    }
}
