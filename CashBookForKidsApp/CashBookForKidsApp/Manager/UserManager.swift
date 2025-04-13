//
//  UserManager.swift
//  CashBookForKidsApp
//
//  Created by 指原奈々 on 2025/04/12.
//

import Foundation
import RealmSwift

class UserManager: ObservableObject {
    static let shared = UserManager()
    
    @Published var savedUsers: [User] = []
    
    private init() { }

    func loadSavedUsers() {
        let savedIds = UserDefaults.standard.stringArray(forKey: "savedUserIds") ?? []
        let realm = try! Realm()
        let users = savedIds.compactMap { id in
            realm.object(ofType: User.self, forPrimaryKey: id)
        }
        DispatchQueue.main.async {
            self.savedUsers = Array(users.prefix(3)) // 上限3人に制限
        }
    }

    func saveUserIds(_ ids: [String]) {
        UserDefaults.standard.set(ids, forKey: "savedUserIds")
        loadSavedUsers()
    }
}
