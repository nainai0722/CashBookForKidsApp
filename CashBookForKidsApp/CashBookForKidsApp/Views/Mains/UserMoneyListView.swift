//
//  UserMoneyListView.swift
//  CashBookForKidsApp
//
//  Created by 指原奈々 on 2025/04/25.
//

import SwiftUI
import RealmSwift

//#Preview("モックたろう") {
//    UserMoneyListView(user: mockUser())
//}

func mockUser() -> User {
    let user = addUser("モックたろう")
    let moneys = [Money(price: 200, moneyType: .income, timestamp: Date(), userID: user.id)]
    let moneyList = List<Money>()
    moneyList.append(objectsIn: moneys)
    user.moneys = moneyList
    return user
}

#Preview("テストユーザー") {
    PreviewProviderForUserMoneyListView.preview
}

struct UserMoneyListView: View {
    @State private var totalMoney: Int = 0
    
    @ObservedRealmObject var user: User
    
    @State private var isShowingIncomeSheet = false
    @State private var isShowingExpenseSheet = false
    @State private var isShowingTaraRevaCalculateSheet = false
    
    @State private var isShowingGoalSetting = false
    @State private var isShowingMoneyDetail = false
    
    @State private var goal: GoalData = GoalData.mockGoal
    @State private var editMoney: MoneyData? = nil
    
    @State private var refreshID = UUID()
    
    // アニメーション用
    @State private var appearedItems: Set<String> = []
    
    var body: some View {
        NavigationStack {
            VStack {
//                このSavingPlanをどこかで使えるようにしたい。
//                Text(getSavingPlan())
                //　ふやす減らすボタン
                ButtonView(
                    editMoney: $editMoney,
                    isShowingIncomeSheet: $isShowingIncomeSheet,
                    isShowingExpenseSheet:$isShowingExpenseSheet,
                    isShowingTaraRevaCalculateSheet: $isShowingTaraRevaCalculateSheet
                )
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
                    MoneyChartView(user: user)
                }
                
                List {
                    let sortedMoneys = Array(user.moneys).sorted(by: { $0.timestamp > $1.timestamp})
                    ForEach(sortedMoneys) { money in
                        MoneyInfoCell(money: castMoneyData(to: money))
                            .onTapGesture {
                                editMoney = castMoneyData(to: money)
                                if money.moneyType == .expense {
                                    isShowingExpenseSheet.toggle()
                                } else {
                                    isShowingIncomeSheet.toggle()
                                }
                            }
                            .offset(y: appearedItems.contains(money.id) ? 0 : -100)
                            .opacity(appearedItems.contains(money.id) ? 1 : 0)
                            .animation(.easeOut(duration: 0.4).delay(Double(user.moneys.firstIndex(where: { $0.id == money.id }) ?? 0) * 0.1), value: appearedItems)
                    }
                    .onDelete { indexSet in
                        deleteMoney(at: indexSet, for: user)
                    }
                }
                .listStyle(.plain)
                .onAppear {
                    let moneysArray = Array(user.moneys) // これ！
                    for (index, money) in moneysArray.enumerated() {
                        DispatchQueue.main.asyncAfter(deadline: .now() + Double(index) * 0.1) {
                            appearedItems.insert(money.id)
                        }
                    }
                }
                .onChange(of: user.moneys.count) { _ in
                    refreshID = UUID()
                    let moneysArray = Array(user.moneys)
                    appearedItems = []
                    for (index, money) in moneysArray.enumerated() {
                        DispatchQueue.main.asyncAfter(deadline: .now() + Double(index) * 0.1) {
                            appearedItems.insert(money.id)
                        }
                    }
                }
            }
        }
        .fullScreenCover(isPresented: $isShowingIncomeSheet) {
            MoneyInsertView(
                isShowFullScreen: $isShowingIncomeSheet,
                editMoney: $editMoney,
                user: user,
                moneyType: .income
            )
        }
        .fullScreenCover(isPresented: $isShowingExpenseSheet) {
            MoneyInsertView(
                isShowFullScreen: $isShowingExpenseSheet,
                editMoney: $editMoney,
                user: user,
                moneyType: .expense
            )
        }
        .fullScreenCover(isPresented: $isShowingTaraRevaCalculateSheet) {
            TaraRevaCalculateView(
                isShowingSheet: $isShowingTaraRevaCalculateSheet,
                user: user
            )
        }
        .onChange(of: refreshID) { _ in
            getTotalMoney()
            print("リフレッシュのたびに呼び出し")
        }
        .onAppear {
            getTotalMoney()
            print("画面表示の際に呼び出し")
        }
    }
    
    /// 目標にしている金額を取得する
    /// - Returns: 目標の金額
    func getSavingPlan() -> String {
        let savingPlan = user.savingPlans.where {$0.isAchieved == false}.first
        if let savingPlan = savingPlan {
            return String(savingPlan.amount)
        }
        return "目標はなし"
    }
    
    func getTotalMoney() {
        totalMoney = user.moneys.reduce(0) { result, money in
           if money.moneyType == .income {
               return result + money.price
           } else {
               return result - money.price
           }
       }
    }
    
    func updateUser(_ user: User) {
        let realm = try! Realm()
        
        let users = realm.objects(User.self)
        let userToUpdate = users.filter { $0.id == user.id }.first!
        
        let money = Money()
        money.price = 200
        money.moneyType = .income
        money.incomeType = .monthlyPayment
        money.memo = "めもめも"
        money.timestamp = Date()
        
        try! realm.write {
            userToUpdate.moneys.append(money)
        }
    }
    
    func deleteMoney(at offsets: IndexSet, for user: User) {
        let realm = try! Realm()

        // thaw して編集可能な状態に
        guard let thawedUser = user.thaw() else { return }

        try! realm.write {
            for index in offsets {
                
                let sortedMoneys = thawedUser.moneys.sorted { $0.timestamp > $1.timestamp }
                
                let moneyToDelete = sortedMoneys[index]
                realm.delete(moneyToDelete)
            }
        }
    }
    
    func castMoneyData(to money: Money) -> MoneyData{
        let moneyData = MoneyData()
        moneyData.id = money.id
        moneyData.price = money.price
        moneyData.moneyType = money.moneyType
        moneyData.incomeType = money.incomeType
        moneyData.expenseType = money.expenseType
        moneyData.memo = money.memo
        moneyData.timestamp = money.timestamp
        return moneyData
    }
}

private struct PreviewProviderForUserMoneyListView {
    static var preview: some View {
        let user = User()
        user.name = "プレビュー太郎"
        user.createdAt = Date()

        let realm = try! Realm(configuration: Realm.Configuration(inMemoryIdentifier: "PreviewRealm"))
        try! realm.write {
            realm.add(user)
        }

        return UserMoneyListView(user: user)
    }
}
