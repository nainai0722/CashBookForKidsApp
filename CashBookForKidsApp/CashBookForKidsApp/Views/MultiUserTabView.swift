//
//  MultiUserTabView.swift
//  CashBookForKidsApp
//
//  Created by 指原奈々 on 2025/04/12.
//

import SwiftUI
import RealmSwift

struct MultiUserTabView: View {
    @State private var savedUsers: [User] = []

    var body: some View {
        TabView {
            ForEach(savedUsers) { user in
                UserDetailView(user: user)
                    .tabItem {
                        Text(user.name)
                    }
            }
        }
        .onAppear {
            loadSavedUsers()
        }
    }

    func loadSavedUsers() {
        let savedIds = UserDefaults.standard.stringArray(forKey: "savedUserIds") ?? []
        let realm = try! Realm()
        let users = savedIds.compactMap { id in
            realm.object(ofType: User.self, forPrimaryKey: id)
        }
        self.savedUsers = Array(users.prefix(3)) // 上限3人に制限
    }
}


#Preview {
    MultiUserTabView()
}
