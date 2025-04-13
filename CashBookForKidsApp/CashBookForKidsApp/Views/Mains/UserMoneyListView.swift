//
//  UserDetailView.swift
//  CashBookForKidsApp
//
//  Created by 指原奈々 on 2025/04/12.
//

import SwiftUI
import RealmSwift

struct UserMoneyListView: View {
    @State private var totalMoney: Int = 0
    
    @ObservedRealmObject var user: User
    
    @State private var isShowingIncomeSheet = false
    @State private var isShowingExpenseSheet = false
    @State private var isShowingGoalSetting = false
    @State private var isShowingMoneyDetail = false
    
    @State private var goal: GoalData = GoalData.mockGoal
    @State private var editMoney: MoneyData? = nil
    
    @State private var refreshID = UUID()
    
    var body: some View {
        NavigationStack {
            VStack {
                Text(user.name)
                //　ふやす減らすボタン
                ButtonView(editMoney: $editMoney, isShowingIncomeSheet: $isShowingIncomeSheet, isShowingExpenseSheet: $isShowingExpenseSheet)
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
                    ForEach(user.moneys) { money in
                        MoneyInfoCell(money: castMoneyData(to: money))
                            .onTapGesture {
                                editMoney = castMoneyData(to: money)
                                if money.moneyType == .expense {
                                    isShowingExpenseSheet.toggle()
                                } else {
                                    isShowingIncomeSheet.toggle()
                                }
                            }
                    }
                    .onDelete { indexSet in
                        deleteMoney(at: indexSet, for: user)
                    }
                }
                .id(refreshID) // ←これ追加
            }
        }
        .sheet(isPresented: $isShowingIncomeSheet) {
            MoneyInputView(
                isShowingSheet: $isShowingIncomeSheet,
                editMoney: $editMoney, refreshID: $refreshID,
                user: user,
                moneyType: .income
            )
        }
        .sheet(isPresented: $isShowingExpenseSheet) {
            MoneyInputView(
                isShowingSheet: $isShowingExpenseSheet,
                editMoney: $editMoney, refreshID: $refreshID,
                user: user,
                moneyType: .expense
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
                let moneyToDelete = thawedUser.moneys[index]
                realm.delete(moneyToDelete)
            }
        }
    }
    
    func deleteLastMoney(_ user: User) {
        let realm = try! Realm()
        
        let users = realm.objects(User.self)
        let userToUpdate = users.filter { $0.id == user.id }.first!
        
        try! realm.write {
            userToUpdate.moneys.removeLast()
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

#Preview("モックたろう") {
    UserMoneyListView(user: addUser("モックたろう"))
}

#Preview("テストユーザー") {
    PreviewProviderForUserMoneyListView.preview
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



func addUser(_ name: String) -> User{
    let realm = try! Realm(configuration: Realm.Configuration(inMemoryIdentifier: "PreviewRealm"))
    
    // すでに同じ名前のユーザーがいるかチェック
    if realm.objects(User.self).filter("name == %@", name).first != nil {
        print("同じ名前のユーザーが存在します。追加をキャンセルします。")
        return User()
    }
    
    let child = User()
    child.name = name
    
    try! realm.write {
        realm.add(child)
        print(child.id)
        
    }
    return child
}

struct ButtonView: View {
    @Binding var editMoney: MoneyData?
    @Binding var isShowingIncomeSheet: Bool
    @Binding var isShowingExpenseSheet: Bool
    var body: some View {
        HStack {
            Button(action: {
                editMoney = nil
                isShowingIncomeSheet.toggle()
            }){
                Text("ふやす")
                    .modifier(CustomGreenButton(fontType: .headline))
            }
            Button(action: {
                editMoney = nil
                isShowingExpenseSheet.toggle()
            }){
                Text("へらす")
                    .modifier(CustomGreenButton(fontType: .headline))
            }
        }
    }
}
