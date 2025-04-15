//
//  CashBookForKidsAppApp.swift
//  CashBookForKidsApp
//
//  Created by 指原奈々 on 2025/04/03.
//

import SwiftUI
import RealmSwift
import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()

    return true
  }
}

@main
struct CashBookForKidsAppApp: SwiftUI.App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    init() {
        initRealm()
        userDataFromRealm()
    }
    
    func initRealm() {
        let config = Realm.Configuration(
            schemaVersion: 2, // ← 今のバージョン +1 にする（例）
            migrationBlock: { migration, oldSchemaVersion in
                if oldSchemaVersion < 2 {
                    // 今回の変更では特に何もする必要はない
                    // Realmが自動的に新しい List プロパティを追加してくれる
                }
            }
        )

        Realm.Configuration.defaultConfiguration = config

        // Realmを使う（初期化）タイミングで有効に
        let realm = try! Realm()
        print("Realm initialized successfully.")
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
