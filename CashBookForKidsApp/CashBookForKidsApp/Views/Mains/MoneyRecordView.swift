//
//  MoneyRecordView.swift
//  YourMoneyApp
//
//  Created by 指原奈々 on 2025/03/02.
//

import SwiftUI
import RealmSwift

struct MoneyRecordView: View {
    @ObservedResults(Money.self) var moneys
    @ObservedResults(UserInfo.self) var userInfos
    
//    @State var mockMoney:[Money] = [Money(),Money(),Money()]
    
    @State private var totalMoney: Int = 0
    @State private var isShowingIncomeSheet = false
    @State private var isShowingExpenseSheet = false
    @State private var isShowingGoalSetting = false
    @State private var isShowingMoneyDetail = false
    @State private var editMoney: Money? = nil
    @State private var goal: GoalData = GoalData.mockGoal

    var body: some View {
        Text("型推論が多すぎてエラー")
//        NavigationStack {
//            MoneySummaryComponent(
//                isShowingGoalSetting: $isShowingGoalSetting,
//                isShowingMoneyDetail: $isShowingMoneyDetail,
//                total: $totalMoney,
//                goal: $goal
//            )
//            .navigationDestination(isPresented: $isShowingGoalSetting) {
//                GoalSettingView(total: totalMoney, goal: goal)
//            }
//            .navigationDestination(isPresented: $isShowingMoneyDetail) {
//                MoneyDetailView()
//            }
//            VStack(spacing: 0) {
//                
//                HStack(spacing: 0) {
//                    Button(action: {
//                        editMoney = nil
//                        isShowingIncomeSheet.toggle()
//                    }) {
//                        Text("ふやす")
//                    }
//                    .modifier(CustomGreenButton(fontType: .title2))
//                
//                    Button(action: {
//                        editMoney = nil
//                        isShowingExpenseSheet.toggle() }) {
//                        Text("へらす")
//                    }
//                    .modifier(CustomGreenButton(fontType: .title2))
//                }
//                
//                List {
//                    ForEach(moneys.sorted(by: { $0.timestamp > $1.timestamp })) { money in
//                        
//                        Button(action: {
//                            editMoney = money
//                            if money.moneyType == .expense {
//                                isShowingExpenseSheet.toggle()
//                            } else {
//                                isShowingIncomeSheet.toggle()
//                            }
//                        }) {
//                            MoneyInfoCell(money: money)
//                        }
////                        NavigationLink {
////                            Text("\(money.price) : \(money.timestamp.formattedString)")
////                        } label: {
////                            MoneyInfoCell(money: money)
////                        }
//                    }
//                    .onDelete(perform: deleteMoneys)
//                }
//                .listStyle(.plain)
//                .sheet(isPresented: $isShowingIncomeSheet) {
//                    MoneyInputView(
//                        isShowingSheet: $isShowingIncomeSheet,
//                        editMoney: $editMoney,
//                        moneyType: .income
//                    )
//                }
//                .sheet(isPresented: $isShowingExpenseSheet) {
//                    MoneyInputView(
//                        isShowingSheet: $isShowingExpenseSheet,
//                        editMoney: $editMoney,
//                        moneyType: .expense
//                    )
//                }
//            }
//        }
//        .onAppear {
//            fetchTotalMoney()
//            loadGoal()
//        }
//        .onChange(of: isShowingIncomeSheet) { fetchTotalMoney() }
//        .onChange(of: isShowingExpenseSheet) { fetchTotalMoney() }
    }

    /// 🔹 **目標を読み込む処理**
    private func loadGoal() {
        if let userInfo = userInfos.first {
            let goals = GoalData.mockGoalsList
            if let currentGoal = goals.filter{ $0.isAchieved == false}.first {
                goal = currentGoal
                return
            }
//            goal = userInfo.goal
        } else {
            print("モックデータを取得")
            let newGoal = GoalData.mockGoal
//            saveUserGoal(goal: newGoal)
//            goal = newGoal
        }
    }

    /// 🔹 **データを保存**
    private func saveUserGoal(goal: Goal) {
//        let userInfo = UserInfo(goal: goal, timestamp: Date())
//        modelContext.insert(userInfo)
//        try? modelContext.save()  // 🔹 **変更を永続化**
    }

    /// 🔹 **総額の計算**
    private func fetchTotalMoney() {
        do {
            let realm = try Realm()
            let allMoneys = realm.objects(Money.self)
            
            guard !allMoneys.isEmpty else {
                totalMoney = 0
                print("お金の記録がありません")
                return
            }

            let income = allMoneys
                .filter("moneyTypeRawValue == %@", MoneyType.income.rawValue)
                .sum(ofProperty: "price") as Int
            
            let expense = allMoneys
                .filter("moneyTypeRawValue == %@", MoneyType.expense.rawValue)
                .sum(ofProperty: "price") as Int
            
            totalMoney = income - expense
            print("総額の再計算: \(totalMoney)")

        } catch {
            print("Realmの初期化に失敗しました: \(error.localizedDescription)")
            totalMoney = 0
        }
    }


    /// 🔹 **データの削除**
    private func deleteMoneys(offsets: IndexSet) {
//        withAnimation {
//            for index in offsets {
//                modelContext.delete(moneys[index])
//            }
//            try? modelContext.save()  // 🔹 **削除後も保存**
//            fetchTotalMoney()
//        }
    }
}

#Preview {
    MoneyRecordView()}
