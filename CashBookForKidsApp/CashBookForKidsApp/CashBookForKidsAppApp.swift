//
//  CashBookForKidsAppApp.swift
//  CashBookForKidsApp
//
//  Created by 指原奈々 on 2025/04/03.
//

import SwiftUI
import RealmSwift

@main
struct CashBookForKidsAppApp: SwiftUI.App {
    init() {
        userDataFromRealm()
    }
    
    func userDataFromRealm() {
        let realm = try! Realm()
        if realm.objects(User.self).isEmpty {
            let defaultUser1 = User()
            defaultUser1.name = "ユーザー1"
            
            let defaultUser2 = User()
            defaultUser2.name = "ユーザー2"
            
            let defaultUser3 = User()
            defaultUser3.name = "ユーザー3"
            
            try! realm.write {
                realm.add(defaultUser1)
                realm.add(defaultUser2)
                realm.add(defaultUser3)
            }
            print("デフォルトユーザーを作成しました")
        } else {
            print("すでにユーザーがいます")
        }
    }
    
    var body: some Scene {
        WindowGroup {
            MultiUserTabView()
        }
    }
}
