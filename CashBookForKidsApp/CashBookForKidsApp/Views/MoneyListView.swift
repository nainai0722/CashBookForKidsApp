//
//  MoneyListView.swift
//  CashBookForKidsApp
//
//  Created by 指原奈々 on 2025/04/11.
//

import SwiftUI
import RealmSwift


struct MoneyListView: View {
    @ObservedResults(User.self,
                     where: { $0.name == "たろう" },
                     sortDescriptor: SortDescriptor(keyPath: "createdAt", ascending: false)) var taroUsers
    
    var body: some View {
        Text(taroUsers.first?.name ?? "")
        HStack {
            Button("ふやす") {
                updateUser(User())
            }
            Button("へらす") {
                updateUser(User())
            }
        }
        
        List {
            ForEach(taroUsers) { user in
                ForEach(user.moneys) { money in
                    HStack {
                        Text(money.moneyType == .income ? "+" : "-")
                        Text("\(money.price)円")
                        Spacer()
                        Text(money.memo ?? "メモなし")
                    }
                }
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
    func deleteMoneyUser(_ user: User) {
        let realm = try! Realm()
        
        let users = realm.objects(User.self)
        let userToUpdate = users.filter { $0.id == user.id }.first!
        

        try! realm.write {
            userToUpdate.moneys.removeLast()
        }
    }
}

#Preview {
//    MoneyListView(name: "たろう")
    MoneyListView()
}
