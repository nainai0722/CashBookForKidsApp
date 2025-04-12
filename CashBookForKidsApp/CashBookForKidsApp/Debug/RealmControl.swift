//
//  RealmControl.swift
//  CashBookForKidsApp
//
//  Created by 指原奈々 on 2025/04/11.
//

import SwiftUI
import RealmSwift

struct RealmControl: View {
    //RealmのオブジェクトをSwiftUIのViewにバインドして、変更を自動でUIに反映させる プロパティラッパー
    @ObservedResults(User.self) var users
    
    // フィルタ付きや並び順付きもできる！
    @ObservedResults(User.self,
                     where: { $0.name == "たろう" },
                     sortDescriptor: SortDescriptor(keyPath: "createdAt", ascending: false)) var taroUsers
    
    @ObservedResults(User.self,
                     where: { $0.name == "はなこ" },
                     sortDescriptor: SortDescriptor(keyPath: "createdAt", ascending: false)) var hanakoUsers
    
    
    
    var body: some View {
        VStack {
            
            Button("ゆの追加") {
                addUser("ゆの")
            }
            
            Button("えま追加") {
                addUser("えま")
            }
            
            Button("はなこ追加") {
                addUser("はなこ")
            }
            
            Button("ユーザー削除") {
                deleteUser()
            }
            
            Button("おこづかい追加") {
                if let user = taroUsers.first {
                    print(user.name)
                    print(user.id)
                    updateUser(user)
                }
            }
            
            Button("おこづかい削除") {
                // 今は未実装
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
    }
    
    func addUser(_ name: String) {
        let realm = try! Realm()
        
        let child = User()
        child.name = name
        
        let money = Money()
        money.price = 1000
        money.moneyType = .income
        money.incomeType = .monthlyPayment
        money.memo = "月のおこづかい"
        money.timestamp = Date()
        
        child.moneys.append(money)
        child.moneys.append(money)
        
        try! realm.write {
            realm.add(child)
            print(child.id)
        }
        saveUserIds(child.id)
        
    }
    
    func saveUserIds(_ ids: String) {
        var savedUserIds = loadUserIds()
        savedUserIds.append(ids)
        UserDefaults.standard.set(savedUserIds, forKey: "savedUserIds")
    }
    
    func loadUserIds() -> [String] {
        return UserDefaults.standard.stringArray(forKey: "savedUserIds") ?? []
    }
    
    
    func deleteUser() {
        let realm = try! Realm()
        
        let users = realm.objects(User.self)
        let userToDelete = users.first!
        
        try! realm.write {
            realm.delete(userToDelete)
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
    

    
}
#Preview {
    RealmControl()
}
