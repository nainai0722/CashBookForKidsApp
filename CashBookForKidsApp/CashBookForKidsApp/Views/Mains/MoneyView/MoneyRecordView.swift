//
//  MoneyRecordView.swift
//  YourMoneyApp
//
//  Created by 指原奈々 on 2025/03/02.
//

import SwiftUI
import SwiftData

struct MoneyRecordView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var moneys: [Money]
    @Query private var userInfos: [UserInfo]
    
    @State private var totalMoney: Int = 0
    @State private var isShowingIncomeSheet = false
    @State private var isShowingExpenseSheet = false
    @State private var isShowingGoalSetting = false
    @State private var isShowingMoneyDetail = false
    
    @State private var goal: Goal = Goal.mockGoal

    var body: some View {
        NavigationSplitView {
            VStack {
                MoneySummaryComponent(
                    isShowingGoalSetting: $isShowingGoalSetting,
                    isShowingMoneyDetail: $isShowingMoneyDetail,
                    total: $totalMoney,
                    goal: $goal
                )
                .navigationDestination(isPresented: $isShowingGoalSetting) {
                    GoalSettingView(total: totalMoney, goal: goal)
                }
                .navigationDestination(isPresented: $isShowingMoneyDetail) {
                    MoneyDetailView()
                }
                
                
            }
            .onAppear {
                fetchTotalMoney()
                loadGoal()
            }
            .background(Color(.systemGray6))
            
            List {
                ForEach(moneys.sorted(by: { $0.timestamp > $1.timestamp })) { money in
                    NavigationLink {
                        Text("\(money.price) : \(money.timestamp.formattedString)")
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
                    Button(action: { isShowingIncomeSheet.toggle() }) {
                        Text("＋　ふやす")
                    }
                }
                ToolbarItem {
                    Button(action: { isShowingExpenseSheet.toggle() }) {
                        Text("ー　へらす")
                    }
                }
            }
            .sheet(isPresented: $isShowingIncomeSheet) {
                MoneyInputView(isShowingSheet: $isShowingIncomeSheet, moneyType: .income)
            }
            .sheet(isPresented: $isShowingExpenseSheet) {
                MoneyInputView(isShowingSheet: $isShowingExpenseSheet, moneyType: .expense)
            }
        } detail: {
            Text("Select an money")
        }
        .background(Color(.systemGray6)) 
        .onChange(of: isShowingIncomeSheet) { fetchTotalMoney() }
        .onChange(of: isShowingExpenseSheet) { fetchTotalMoney() }
    }

    /// 🔹 **目標を読み込む処理**
    private func loadGoal() {
        if let userInfo = userInfos.first {
            let goals = Goal.mockGoalsList
            if let currentGoal = goals.filter{ $0.isAchieved == false}.first {
                goal = currentGoal
                return
            }
            goal = userInfo.goal
        } else {
            print("モックデータを取得")
            let newGoal = Goal.mockGoal
            saveUserGoal(goal: newGoal)
            goal = newGoal
        }
    }

    /// 🔹 **データを保存**
    private func saveUserGoal(goal: Goal) {
        let userInfo = UserInfo(goal: goal, timestamp: Date())
        modelContext.insert(userInfo)
        try? modelContext.save()  // 🔹 **変更を永続化**
    }

    /// 🔹 **総額の計算**
    private func fetchTotalMoney() {
        let fetchDescriptor = FetchDescriptor<Money>()
        if let allMoneys = try? modelContext.fetch(fetchDescriptor) {
            let expense = allMoneys.filter { $0.moneyType == .expense }.reduce(0) { $0 + $1.price }
            let income = allMoneys.filter { $0.moneyType == .income }.reduce(0) { $0 + $1.price }
            totalMoney = income - expense
            print("総額の再計算: \(totalMoney)")
        }
    }

    /// 🔹 **データの削除**
    private func deleteMoneys(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(moneys[index])
            }
            try? modelContext.save()  // 🔹 **削除後も保存**
            fetchTotalMoney()
        }
    }
}

#Preview {
    MoneyRecordView()
        .modelContainer(for: Money.self)
}
