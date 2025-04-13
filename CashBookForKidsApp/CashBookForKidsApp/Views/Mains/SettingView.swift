//
//  SettingView.swift
//  CashBookForKidsApp
//
//  Created by 指原奈々 on 2025/04/12.
//

import SwiftUI
import RealmSwift

struct SettingView: View {
    @ObservedResults(User.self) var users
    @State private var path = NavigationPath()
    var body: some View {
        NavigationStack {
            Text("ユーザー情報を変更する")
            List(users) { user in
                NavigationLink {
                    EditUserView(user: user, userData: castUserData(user))
                    
                } label: {
                    Text(user.name)
                }
            }
            
            List {
                NavigationLink {
                    AddUserView()
                    
                } label: {
                    Text("新規ユーザーを追加")
                }
            }
        }
    }
    
    func castUserData(_ user: User) -> UserData {
        return UserData(id: user.id, name: user.name, createdAt: user.createdAt, updatedAt: user.updatedAt)
        
    }
}

#Preview {
    SettingView()
}

struct EditUserView: View {
    @Environment(\.dismiss) var dismiss
    
    @ObservedRealmObject var user: User
    @State var userData: UserData
    @State private var showAlert = false
    var body: some View {
        VStack {
            Text(user.name)
            TextField("名前を入力", text: $userData.name)
                .textFieldStyle(.roundedBorder)
                .textCase(.lowercase)
                .multilineTextAlignment(.trailing)
            Button("更新") {
                updateUser(user)
                dismiss()
            }
            Button("削除") {
                showAlert = true
            }
            .alert("ユーザーを削除しますか？", isPresented: $showAlert) {
                Button("削除", role: .destructive) {
                    deleteUser(user)
                    dismiss()
                }
                Button("キャンセル", role: .cancel) {}
            }
        }
    }

    func updateUser(_ user: User) {
        let realm = try! Realm()
        
        let users = realm.objects(User.self)
        let userToUpdate = users.filter { $0.id == user.id }.first!
        
        try! realm.write {
            userToUpdate.name = userData.name
        }
    }
    
    func deleteUser(_ user: User) {
        let realm = try! Realm()
        
        let users = realm.objects(User.self)
        let userToDelete = users.filter {$0.id == user.id }.first!
        
        try! realm.write {
            realm.delete(userToDelete)
        }
    }
}

struct AddUserView: View {
    @Environment(\.dismiss) var dismiss
    @State var newUSerName: String = ""
    var body: some View {
        VStack {
            Text("新規ユーザー")
            TextField("名前を入力", text: $newUSerName)
                .textFieldStyle(.roundedBorder)
                .textCase(.lowercase)
                .multilineTextAlignment(.trailing)
            Button("追加") {
                addUser(newUSerName)
                dismiss()
            }
        }
    }
    func addUser(_ name: String) {
        let realm = try! Realm()
        
        // すでに同じ名前のユーザーがいるかチェック
        if realm.objects(User.self).filter("name == %@", name).first != nil {
            print("同じ名前のユーザーが存在します。追加をキャンセルします。")
            return
        }
        
        let child = User()
        child.name = name
        
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
}


#Preview {
    EditUserView(user: User(), userData: UserData(id: "111", name: "ユーザー変更", createdAt: Date(), updatedAt: Date()))
}
