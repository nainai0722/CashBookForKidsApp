//
//  UserDetailView.swift
//  CashBookForKidsApp
//
//  Created by 指原奈々 on 2025/04/12.
//

import SwiftUI
import RealmSwift

struct UserDetailView: View {
    @State private var totalMoney: Int = 0
    
    @ObservedRealmObject var user: User
    
    @State private var isShowingIncomeSheet = false
    @State private var isShowingExpenseSheet = false
    @State private var isShowingGoalSetting = false
    @State private var isShowingMoneyDetail = false
    
    @State private var goal: GoalData = GoalData.mockGoal
    @State private var editMoney: MoneyData? = nil
    
    var body: some View {
        NavigationStack {
            VStack {
                Text(user.name)
                HStack {
                    Button("ふやす") {
                        editMoney = nil
//                        updateUser(user)
                        isShowingIncomeSheet.toggle()
                    }
                    Button("へらす") {
                        editMoney = nil
//                        deleteLastMoney(user)
                        isShowingExpenseSheet.toggle()
                    }
                }
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
                
                List {
                    ForEach(user.moneys) { money in
                        
                        Button(action: {
                            editMoney = castMoneyData(to: money)
                            if money.moneyType == .expense {
                                isShowingExpenseSheet.toggle()
                            } else {
                                isShowingIncomeSheet.toggle()
                            }
                        }) {
                            MoneyInfoCell(money: castMoneyData(to: money))
                        }
                        
                    }
                }
            }
        }
        .sheet(isPresented: $isShowingIncomeSheet) {
            MoneyInputView(
                isShowingSheet: $isShowingIncomeSheet,
                editMoney: $editMoney,
                user: user,
                moneyType: .income
            )
        }
        .sheet(isPresented: $isShowingExpenseSheet) {
            MoneyInputView(
                isShowingSheet: $isShowingExpenseSheet,
                editMoney: $editMoney,
                user: user,
                moneyType: .expense
            )
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
        moneyData.memo = money.memo
        moneyData.timestamp = money.timestamp
        return moneyData
    }
}

#Preview {
    UserDetailView(user: User())
}
